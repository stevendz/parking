import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/auth_screen.dart';
import 'package:parking/widgets/primary_button.dart';

class PleaseLoginDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(5),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Please login to use this feature.'),
          ),
          PrimaryButton(
            color: Theme.of(context).primaryColor,
            onClick: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthScreen(),
                ),
              );
            },
            text: 'Login',
          ),
          FlatButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(isSignUp: true),
                  ),
                );
              },
              child: Text('Or signup now'))
        ],
      ),
    );
  }
}
