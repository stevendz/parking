import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking/screens/auth_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking/screens/post_slot_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController newUsernameController = TextEditingController();
  User user;
  initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    StorageReference imgStorage = FirebaseStorage.instance.ref();
    CollectionReference usersDb =
        FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: usersDb.doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Profile'),
              ),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        PickedFile pickedImage = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        StorageUploadTask uploadTask = imgStorage
                            .child(user.email + '_avatar')
                            .putFile(File(pickedImage.path));
                        String url = await (await uploadTask.onComplete)
                            .ref
                            .getDownloadURL();
                        setState(() {
                          usersDb.doc(user.uid).set(
                            {'username': data['username'], 'avatarUrl': url},
                          );
                        });
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(data['avatarUrl']),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            contentPadding: EdgeInsets.all(10),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextFormField(
                                  controller: newUsernameController,
                                  decoration: InputDecoration(
                                      labelText: 'New username'),
                                ),
                                SizedBox(height: 10),
                                FlatButton(
                                  color: Theme.of(context).primaryColorLight,
                                  onPressed: () {
                                    if (newUsernameController.text
                                            .trim()
                                            .length >
                                        3) {
                                      setState(() {
                                        usersDb.doc(user.uid).set(
                                          {
                                            'username':
                                                newUsernameController.text,
                                            'avatarUrl': data['avatarUrl']
                                          },
                                        );
                                        newUsernameController.text = '';
                                      });
                                      Get.back();
                                    }
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(data['username']),
                          ),
                          Icon(
                            Icons.edit,
                            size: 12,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    Text(user.email),
                    Divider(),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Get.to(PostSlotScreen());
                      },
                      child: Text('Add new parking slot'),
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColorLight,
                      onPressed: () async {},
                      child: Text('Manage parking slots'),
                    ),
                    Divider(),
                    FlatButton(
                      color: Colors.redAccent,
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Get.off(AuthScreen());
                      },
                      child: Text('logout'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Material(child: Center(child: Text("loading...")));
        });
  }
}
