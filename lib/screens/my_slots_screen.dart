import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySlotsScreen extends StatefulWidget {
  @override
  _MySlotsScreenState createState() => _MySlotsScreenState();
}

class _MySlotsScreenState extends State<MySlotsScreen> {
  CollectionReference slotsDb = FirebaseFirestore.instance.collection('slots');
  User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: slotsDb.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData) {
            var data = snapshot.data.docs
                .where((element) => element.data()['userUid'] == user.uid)
                .toList();
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Profile'),
              ),
              body: data.length == 0
                  ? Center(child: Text('You have no active slots'))
                  : ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        data[index].data()['imageUrl'],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              title: Text(data[index].data()['title']),
                            ),
                            Divider()
                          ],
                        );
                      },
                    ),
            );
          }

          return Material(child: Center(child: Text("loading...")));
        });
  }
}
