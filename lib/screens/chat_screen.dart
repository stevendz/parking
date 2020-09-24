import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key key, this.chatId = 'iXO4GMVfU1Ldjj5Fn7HQ'})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static CollectionReference chatsDb =
      FirebaseFirestore.instance.collection('chats');
  CollectionReference messagesDb;

  User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    messagesDb = chatsDb.doc(widget.chatId).collection('messages');
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
          var data = snapshot.data.docs.toList();
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
                        maxLines: 4,
                        minLines: 1,
                      ),
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
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
