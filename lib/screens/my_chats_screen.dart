import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/widgets/chat.dart';

class MyChatsScreen extends StatefulWidget {
  @override
  _MyChatsScreenState createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  static CollectionReference chatsDb =
      FirebaseFirestore.instance.collection('chats');
  User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  getChatPartner(chatPartners) {
    chatPartners.removeWhere((item) => item == user.uid);
    return chatPartners[0];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatsDb.where('members', arrayContains: user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData) {
          var data = snapshot.data.docs.asMap();
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Chats'),
            ),
            body: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                String chatPartner =
                    getChatPartner(data[index].data()['members']);
                return Chat(
                    chatPartner: chatPartner,
                    id: data[index].id,
                    object: data[index].data()['object']);
              },
            ),
          );
        }
        return Material(child: Center(child: Text("loading...")));
      },
    );
  }
}
