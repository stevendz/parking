import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/map_screen.dart';
import 'package:get/get.dart';
import 'package:parking/services/exception_handler.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSignUp = true;
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
        Get.off(MapScreen());
      }
    } catch (error) {
      setState(() {
        errorMessage = signinExceptionMessage(error.code);
      });
    }
  }

  void signup() async {
    try {
      if (nameController.text.trim().length < 6 ||
          passwordController.text.trim().length < 3) {
        setState(() {
          errorMessage = 'Email or Password too short';
        });
        return;
      }
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: nameController.text, password: passwordController.text);
      if (user != null) {
        Get.off(MapScreen());
      }
    } catch (error) {
      setState(() {
        errorMessage = sigupExceptionMessage(error.code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? MapScreen()
        : SafeArea(
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    TextFormField(
                      controller: nameController,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                    ),
                    SizedBox(height: 20),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        isSignUp ? signup() : signin();
                      },
                      child: Text(isSignUp ? 'Register' : 'Login'),
                    ),
                    // Admin login-button for debugging
                    FlatButton(
                      color: Colors.grey.shade300,
                      onPressed: () async {
                        UserCredential user = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: 'admin@gmail.com', password: '123456');
                        if (user != null) {
                          Get.off(MapScreen());
                        }
                      },
                      child: Text(
                        'admin login',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Spacer(),
                    FlatButton(
                      color: Theme.of(context).primaryColorLight,
                      onPressed: () {
                        setState(() {
                          errorMessage = '';
                          isSignUp = !isSignUp;
                        });
                      },
                      child: Text(isSignUp
                          ? 'Already an user? Login!'
                          : 'No account? Register!'),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
