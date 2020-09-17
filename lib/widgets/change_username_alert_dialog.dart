import 'package:flutter/material.dart';

class ChangeUsernameDialog extends StatelessWidget {
  final Function updateUsername;
  final String username;

  const ChangeUsernameDialog({
    Key key,
    @required this.updateUsername,
    @required this.username,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController newUsernameController = TextEditingController();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: newUsernameController,
                  decoration: InputDecoration(labelText: 'New username'),
                ),
                SizedBox(height: 10),
                FlatButton(
                  color: Theme.of(context).primaryColorLight,
                  onPressed: () {
                    updateUsername(newUsernameController.text);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(3),
            child: Text(username),
          ),
          Icon(
            Icons.edit,
            size: 12,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
