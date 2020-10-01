import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    @required this.message,
    @required this.myMessage,
  }) : super(key: key);

  final String message;
  final bool myMessage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: myMessage
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(50)),
        child: Text(
          message,
          style: TextStyle(color: myMessage ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
