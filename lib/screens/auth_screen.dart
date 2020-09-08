import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/map_screen.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  void signin() async {
    try {
      var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
      if (user != null) {
        Get.to(MapScreen());
      }
    } catch (e) {
      print(e);
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
            ],
          ),
        ),
      ),
    );
  }
}
