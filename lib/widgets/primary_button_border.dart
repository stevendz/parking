import 'package:flutter/material.dart';

class PrimaryButtonBorder extends StatelessWidget {
  final String text;
  final Function onClick;
  final Color color;
  final bool big;

  const PrimaryButtonBorder({
    Key key,
    @required this.text,
    @required this.onClick,
    this.color,
    this.big: false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: big ? double.infinity : null,
      child: OutlineButton(
        borderSide:
            BorderSide(color: color != null ? color : Colors.white, width: 2),
        padding: EdgeInsets.all(big ? 15 : 12),
        onPressed: onClick != null ? onClick : null,
        textColor: color != null ? color : Colors.white,
        disabledTextColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text != null ? text : 'text',
          style: TextStyle(
            fontSize: big ? 18 : 14,
          ),
        ),
      ),
    );
  }
}
