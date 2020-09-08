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
      if (user != null) {
        Get.to(MapScreen());
      }
    } catch (error) {
      print(error);
      switch (error.code) {
        case "invalid-email":
          setState(() {});
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          setState(() {
            errorMessage = "Your password is wrong.";
          });
          break;
        case "user-not-found":
          setState(() {
            errorMessage = "User with this email doesn't exist.";
          });
          break;
        case "user-disabled":
          setState(() {
            errorMessage = "User with this email has been disabled.";
          });
          break;
        case "too-many-requests":
          setState(() {
            errorMessage = "Too many requests. Try again later.";
          });
          break;
        case "operation-not-allowed":
          setState(() {
            errorMessage = "Signing in with Email and Password is not enabled.";
          });
          break;
        default:
          setState(() {
            errorMessage = "An undefined Error happened.";
          });
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
