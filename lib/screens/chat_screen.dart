import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/widgets/message_bubble.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String chatPartner;
  final String chatId;
  final String object;

  const ChatScreen({
    Key key,
    this.chatPartner,
    this.chatId,
    this.object,
  }) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static CollectionReference chatsDb =
      FirebaseFirestore.instance.collection('chats');
  TextEditingController chatController = TextEditingController();
  String chatUid;
  User user;
  bool exists = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (widget.chatId == null) {
      chatUid = Uuid().v1();
      exists = false;
    } else {
      chatUid = widget.chatId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: chatsDb.doc(chatUid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData) {
          var data = snapshot.data.data() != null
              ? snapshot.data.data()['messages']
              : null;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: FittedBox(child: Text(widget.object)),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(5),
                    itemCount: data != null ? data.length : 0,
                    itemBuilder: (context, index) {
                      bool isMyMessage = data[index]['sender'] == user.uid;
                      return MessageBubble(
                          message: data[index]['message'],
                          myMessage: isMyMessage);
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
                      onPressed: sendMessage,
                      child: Text('send'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Material(child: Center(child: Text("loading...")));
      },
    );
  }

  void sendMessage() {
    if (chatController.text.trim().length > 0) {
      if (!exists) {
        chatsDb.doc(chatUid).set({
          'members': [user.uid, widget.chatPartner],
          'object': widget.object,
          'messages': FieldValue.arrayUnion([
            {
              'message': chatController.text,
              'sender': user.uid,
              'timestamp': DateTime.now()
            }
          ])
        });
        exists = true;
      } else {
        chatsDb.doc(chatUid).update({
          'messages': FieldValue.arrayUnion([
            {
              'message': chatController.text,
              'sender': user.uid,
              'timestamp': DateTime.now()
            }
          ])
        });
      }
      setState(() {
        chatController.text = '';
      });
    }
  }
}
