import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/map_screen.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController();

  final passwordController = TextEditingController();

  String errorMessage = '';

  void signin() async {
    try {
      if (nameController.text.trim().length < 6 ||
          passwordController.text.trim().length < 6) {
        setState(() {
          errorMessage = 'Email or Password too short';
        });
        return;
      }
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: nameController.text, password: passwordController.text);
      // if (user != null) {
      //   Get.to(MapScreen());
      // }
    } catch (error) {
      print(error);
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
              ),
              FlatButton(
                onPressed: () {
                  print('Name: ' + nameController.text);
                  print('Password: ' + passwordController.text);
                  signin();
                },
                child: Text('Login'),
              ),
              Text(errorMessage),
            ],
          ),
        ),
      ),
    );
  }
}
