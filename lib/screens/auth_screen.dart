import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/map_screen.dart';
import 'package:get/get.dart';
import 'package:parking/services/exception_handler.dart';
import 'package:parking/widgets/user_auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  CollectionReference usersDb = FirebaseFirestore.instance.collection('users');
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSignUp = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    usernameController.text = 'StevenDz';
    emailController.text = 'contact@stevendz.de';
    passwordController.text = '123456';
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return MapScreen();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/parking-41df9.appspot.com/o/logo.png?alt=media',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
            Text(
              'parking',
              style: TextStyle(
                  fontSize: 40, color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            UserAuthForm(
              isSignUp: isSignUp,
              usernameController: usernameController,
              emailController: emailController,
              passwordController: passwordController,
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
            // FlatButton(
            //   color: Colors.grey.shade300,
            //   onPressed: () async {
            //     UserCredential user =
            //         await FirebaseAuth.instance.signInWithEmailAndPassword(
            //       email: 'admin@gmail.com',
            //       password: '123456',
            //     );
            //     if (user != null) {
            //       Get.off(MapScreen());
            //     }
            //   },
            //   child: Text(
            //     'admin login',
            //     style: TextStyle(fontSize: 12),
            //   ),
            // ),
            Spacer(),
            FlatButton(
              color: Theme.of(context).primaryColorLight,
              onPressed: () {
                setState(() {
                  errorMessage = '';
                  isSignUp = !isSignUp;
                });
              },
              child: Text(
                isSignUp ? 'Already an user? Login!' : 'No account? Register!',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signin() async {
    try {
      if (emailController.text.trim().length < 6 ||
          passwordController.text.trim().length < 6) {
        setState(() {
          errorMessage = 'Email or Password too short';
        });
        return;
      }
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      if (user != null) {
        Get.off(MapScreen());
      }
    } catch (error) {
      setState(() {
        errorMessage = authExceptionMessage(error.code);
      });
    }
  }

  void signup() async {
    try {
      if (emailController.text.trim().length < 6 ||
          passwordController.text.trim().length < 3) {
        setState(() {
          errorMessage = 'Email or Password too short';
        });
        return;
      }
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      if (user != null) {
        usersDb.doc(user.user.uid).set({
          'username': usernameController.text,
          'avatarUrl':
              'https://tanzolymp.com/images/default-non-user-no-photo-1.jpg'
        });
        Get.off(MapScreen());
      }
    } catch (error) {
      setState(() {
        errorMessage = authExceptionMessage(error.code);
      });
    }
  }
}
