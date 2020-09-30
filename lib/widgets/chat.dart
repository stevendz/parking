import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking/screens/chat_screen.dart';

class Chat extends StatefulWidget {
  const Chat({
    Key key,
    @required this.chatPartner,
    @required this.id,
    @required this.object,
  }) : super(key: key);

  final String chatPartner;
  final String id;
  final String object;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  static CollectionReference usersDb =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersDb.doc(widget.chatPartner).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          } else {
            return ListTile(
              onTap: () {
                Get.to(
                  ChatScreen(
                    chatPartner: snapshot.data.data()['username'],
                    chatId: widget.id,
                    object: widget.object,
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshot.data.data()['avatarUrl']),
              ),
              title: Text(widget.object),
              subtitle: Text(snapshot.data.data()['username']),
            );
          }
        });
  }
}
