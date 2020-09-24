import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
              ],
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
}
