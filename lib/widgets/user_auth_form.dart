import 'package:flutter/material.dart';

class UserAuthForm extends StatelessWidget {
  const UserAuthForm({
    Key key,
    @required this.isSignUp,
    @required this.usernameController,
    @required this.emailController,
    @required this.passwordController,
  }) : super(key: key);

  final bool isSignUp;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: isSignUp,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Username'),
            style: TextStyle(fontSize: 20),
            controller: usernameController,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          style: TextStyle(fontSize: 20),
          controller: emailController,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Password'),
          style: TextStyle(fontSize: 20),
          obscureText: true,
          controller: passwordController,
        ),
      ],
    );
  }
}
