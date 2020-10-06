import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:parking/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking/screens/my_slots_screen.dart';
import 'package:parking/screens/post_slot_screen.dart';
import 'package:parking/widgets/primary_button_border.dart';
import 'package:parking/widgets/change_username_alert_dialog.dart';
import 'package:parking/widgets/primary_button.dart';

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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Profile',
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      PickedFile pickedImage = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (pickedImage == null) return;
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
                      backgroundColor: Theme.of(context).primaryColorLight,
                      backgroundImage: NetworkImage(data['avatarUrl']),
                    ),
                  ),
                  Spacer(),
                  ChangeUsernameDialog(
                    updateUsername: updateUsername,
                    username: data['username'],
                  ),
                  Text(user.email),
                  Spacer(),
                  Spacer(),
                  Divider(),
                  Spacer(),
                  PrimaryButton(
                      text: 'Add new parking space',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostSlotScreen(),
                          ),
                        );
                      },
                      color: Theme.of(context).primaryColor),
                  Spacer(),
                  PrimaryButtonBorder(
                    text: 'Manage parking spaces',
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MySlotsScreen(),
                        ),
                      );
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  Divider(),
                  Spacer(),
                  PrimaryButton(
                    text: 'Logout',
                    onClick: signOut,
                    color: Colors.redAccent.shade100,
                  ),
                ],
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
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
      Navigator.pop(context);
    }
  }
}
