import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/screens/edit_slot_screen.dart';
import 'package:parking/screens/profile_screen.dart';

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
                          Dismissible(
                            key: Key(data[index].id),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditSlotScreen(
                                      slot: data[index],
                                    ),
                                  ),
                                );
                              }
                              if (direction == DismissDirection.endToStart) {
                                print(data[index].data());
                                // slotsDb.doc(data[index].id).delete();
                              }
                            },
                            background: Container(
                              color: Theme.of(context).primaryColorLight,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Icon(Icons.edit),
                            ),
                            secondaryBackground: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Icon(Icons.delete_outline,
                                  color: Colors.white),
                            ),
                            child: Column(
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
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          );
        }
        return Material(child: Center(child: Text("loading...")));
      },
    );
  }
}
