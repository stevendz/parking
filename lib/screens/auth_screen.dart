import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/map_screen.dart';
import 'package:get/get.dart';
import 'package:parking/services/exception_handler.dart';
import 'package:parking/widgets/primary_button.dart';
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background2.png'),
              colorFilter: ColorFilter.mode(Colors.white70, BlendMode.screen),
              fit: BoxFit.cover),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            Image.asset(
              'assets/images/logo_color.png',
              fit: BoxFit.cover,
              width: 75,
              height: 75,
            ),
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
            SizedBox(height: 20),
            PrimaryButton(
                text:
                    isSignUp ? 'Register'.toUpperCase() : 'Login'.toUpperCase(),
                onClick: () {
                  isSignUp ? signup() : signin();
                }),
            Spacer(),
            FlatButton(
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
