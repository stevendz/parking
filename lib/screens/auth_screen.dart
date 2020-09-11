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
      print(error);
      switch (error.code) {
        case "invalid-email":
          setState(() {
            errorMessage = "Your email address appears to be malformed.";
          });
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
      print(error.code);
      switch (error.code) {
        case "operation-not-allowed":
          setState(() {
            errorMessage = "Anonymous accounts are not enabled";
          });
          break;
        case "weak-password":
          setState(() {
            errorMessage = "Your password is too weak";
          });
          break;
        case "invalid-email":
          setState(() {
            errorMessage = "Your email is invalid";
          });
          break;
        case "email-already-in-use":
          setState(() {
            errorMessage = "Email is already in use on different account";
          });
          break;
        case "invalid-credential":
          setState(() {
            errorMessage = "Your email is invalid";
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
    return FirebaseAuth.instance.currentUser != null
        ? MapScreen()
        : SafeArea(
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
