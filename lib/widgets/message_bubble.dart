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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: myMessage
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(50)),
        child: Text(
          message,
        ),
      ),
    );
  }
}
