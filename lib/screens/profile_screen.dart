import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking/screens/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;
  String name = '...';
  CollectionReference usersDb = FirebaseFirestore.instance.collection('users');
  initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    print(user.uid);
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
                title: Text(user != null ? user.email : 'Guest'),
              ),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(data['avatarUrl']),
                    ),
                    Text(data['username']),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          color: Theme.of(context).primaryColorLight,
                          onPressed: () {},
                          child: Text('edit'),
                        ),
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
                  ],
                ),
              ),
            );
          }

          return Material(child: Center(child: Text("loading...")));
        });
  }
}
