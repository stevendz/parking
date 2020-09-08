import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(),
              TextFormField(),
              FlatButton(onPressed: () {}, child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
