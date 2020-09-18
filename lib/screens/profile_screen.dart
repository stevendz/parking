import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking/screens/auth_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking/screens/my_slots_screen.dart';
import 'package:parking/screens/post_slot_screen.dart';
import 'package:parking/widgets/change_username_alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference usersDb = FirebaseFirestore.instance.collection('users');
  StorageReference imgStorage = FirebaseStorage.instance.ref();
  User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
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
                        usersDb.doc(user.uid).update(
                          {'avatarUrl': url},
                        );
                      });
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(data['avatarUrl']),
                    ),
                  ),
                  ChangeUsernameDialog(
                    updateUsername: updateUsername,
                    username: data['username'],
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
                    onPressed: () {
                      Get.to(MySlotsScreen());
                    },
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
      },
    );
  }

  void updateUsername(newUsername) {
    if (newUsername.trim().length > 3) {
      setState(() {
        usersDb.doc(user.uid).update(
          {
            'username': newUsername,
          },
        );
      });
      Get.back();
    }
  }
}
