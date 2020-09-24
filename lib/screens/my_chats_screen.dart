import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking/screens/chat_screen.dart';

class MyChatsScreen extends StatefulWidget {
  @override
  _MyChatsScreenState createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  static CollectionReference usersDb =
      FirebaseFirestore.instance.collection('users');
  static CollectionReference chatsDb =
      FirebaseFirestore.instance.collection('chats');
  User user;
  List<String> chatPartners = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    getChats();
  }

  getChats() async {
    var chatssnap = await usersDb.doc(user.uid).get();
    setState(() {
      chatssnap.data()['chats'].forEach((chat) =>
          {chatPartners.add(chat.toString().replaceAll(user.uid, ''))});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatsDb.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData && chatPartners != null) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Chats'),
            ),
            body: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: chatPartners.length,
              itemBuilder: (context, index) {
                return FlatButton(
                  onPressed: () {
                    Get.to(
                      ChatScreen(
                        chatPartner: chatPartners[index],
                      ),
                    );
                  },
                  child: Text(
                    chatPartners[index],
                  ),
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
