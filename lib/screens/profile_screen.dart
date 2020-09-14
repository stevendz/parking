import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              body: Column(
                children: [
                  Text(data['name']),
                  Image.network(data['avatarUrl'])
                ],
              ),
            );
          }

          return Material(child: Center(child: Text("loading...")));
        });
  }
}
