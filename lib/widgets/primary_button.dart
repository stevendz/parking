import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onClick;
  final Color color;
  final bool big;

  const PrimaryButton({
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
      child: FlatButton(
        onPressed: onClick,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: color != null ? color : Colors.white,
        padding: EdgeInsets.all(big ? 15 : 13),
        child: Text(
          text,
          style: TextStyle(
            color:
                color != null ? Colors.white : Theme.of(context).primaryColor,
            fontSize: big ? 18 : 14,
          ),
        ),
      ),
    );
  }
}
