import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking/screens/auth_screen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PickedFile newImage;
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
                        StorageReference reference =
                            imgStorage.child(user.email + '_avatar');
                        StorageUploadTask storageUploadTask =
                            reference.putFile(File(pickedImage.path));

                        await reference.getDownloadURL().then(
                              (url) => setState(
                                () {
                                  usersDb.doc(user.uid).set(
                                    {
                                      'username': data['username'],
                                      'avatarUrl': url
                                    },
                                  );
                                },
                              ),
                            );
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(data['avatarUrl']),
                      ),
                    ),
                    Text(data['username']),
                    Text(user.email),
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
