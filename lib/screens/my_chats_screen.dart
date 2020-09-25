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
  List<String> chatIds = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  getChats() async {
    var chatssnap = await usersDb.doc(user.uid).get();
    setState(() {
      if (chatssnap.data()['chats'] != null) {
        chatssnap.data()['chats'].forEach(
              (chat) => {
                if (!chatIds.contains(chat)) chatIds.add(chat.toString()),
              },
            );
        chatIds.asMap().forEach((index, value) {
          chatsDb.doc(chatIds[index]).get().then((value) => {
                if (value.data() != null)
                  value.data().forEach((key, value) {
                    value.forEach(
                      (member) => {
                        if (member != user.uid) {chatPartners.add(member)}
                      },
                    );
                  })
              });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (chatPartners.isEmpty) getChats();
    return StreamBuilder<QuerySnapshot>(
      stream: usersDb.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Chats'),
            ),
            body: chatIds.length == 0 || chatPartners.isEmpty
                ? Center(child: Text('You have no active chats'))
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: chatIds.length,
                    itemBuilder: (context, index) {
                      print(chatIds);
                      print(chatPartners);
                      var chatPartnerData = snapshot.data.docs
                          .where((user) => user.id == chatPartners[index])
                          .toList();
                      return ListTile(
                        onTap: () {
                          Get.to(
                            ChatScreen(
                              chatPartner: chatPartners[index],
                              chatId: chatIds[index],
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              chatPartnerData[0].data()['avatarUrl']),
                        ),
                        title: Text(
                          chatPartnerData[0].data()['username'],
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
