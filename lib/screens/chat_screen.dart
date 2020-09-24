import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String chatPartner;

  const ChatScreen({
    Key key,
    this.chatPartner,
  }) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static CollectionReference chatsDb =
      FirebaseFirestore.instance.collection('chats');
  static CollectionReference usersDb =
      FirebaseFirestore.instance.collection('users');
  CollectionReference messagesDb;
  TextEditingController chatController = TextEditingController();
  String uuid = Uuid().v1();
  User user;
  String chatId;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    chatId = user.uid + widget.chatPartner;
    messagesDb = chatsDb.doc(chatId).collection('messages');
  }

  checkIfChatExists() async {
    bool exists = false;
    var chatssnap = await usersDb.doc(user.uid).get();
    if (chatssnap.data()['chats'] != null) {
      chatssnap.data()['chats'].forEach((chatId) => {
            if (chatId == chatId) {exists = true}
          });
    }
    if (!exists) {
      usersDb.doc(user.uid).update({
        'chats': FieldValue.arrayUnion([chatId])
      });
      usersDb.doc(widget.chatPartner).update({
        'chats': FieldValue.arrayUnion([chatId])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesDb.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData) {
          var data = snapshot.data.docs.reversed.toList();
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Chat'),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    reverse: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: data[index].data()['uid'] == user.uid
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          data[index].data()['message'],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: chatController,
                        maxLines: 4,
                        minLines: 1,
                      ),
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        checkIfChatExists();
                        messagesDb.doc(uuid).set({
                          'message': chatController.text,
                          'uid': user.uid,
                        });
                        setState(() {
                          uuid = Uuid().v1();
                        });
                      },
                      child: Text('send'),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return Material(child: Center(child: Text("loading...")));
      },
    );
  }
}
