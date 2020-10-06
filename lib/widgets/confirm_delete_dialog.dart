import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking/widgets/primary_button.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final id;

  const ConfirmDeleteDialog({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'You realy want to delete this parking space?',
              textAlign: TextAlign.center,
            ),
          ),
          PrimaryButton(
            color: Colors.redAccent.shade100,
            onClick: () async {
              await FirebaseFirestore.instance
                  .collection('slots')
                  .doc(id)
                  .delete();
              Navigator.pop(context);
            },
            text: 'Delete',
          ),
        ],
      ),
    );
  }
}
