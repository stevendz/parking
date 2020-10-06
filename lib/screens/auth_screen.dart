import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/screens/map_screen.dart';
import 'package:parking/services/exception_handler.dart';
import 'package:parking/widgets/primary_button.dart';
import 'package:parking/widgets/social_authentication.dart';
import 'package:parking/widgets/user_auth_form.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignUp;

  const AuthScreen({Key key, this.isSignUp: false}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  CollectionReference usersDb = FirebaseFirestore.instance.collection('users');
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSignUp;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    isSignUp = widget.isSignUp;
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
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  colorFilter: ColorFilter.mode(
                      Colors.grey.shade100.withOpacity(0.85), BlendMode.screen),
                  fit: BoxFit.cover),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Image.asset(
                    'assets/images/logo_color.png',
                    width: 75,
                    height: 75,
                  ),
                  Spacer(),
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
                    text: isSignUp
                        ? 'Sign up'.toUpperCase()
                        : 'Login'.toUpperCase(),
                    onClick: () {
                      isSignUp ? signup() : signin();
                    },
                    big: true,
                  ),
                  SocialAuthentication(),
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        errorMessage = '';
                        isSignUp = !isSignUp;
                      });
                    },
                    child: Text(
                      isSignUp
                          ? 'Already have an account? Login.'
                          : 'Don’t have an account? Sign up.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(),
          ),
        );
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MapScreen()));
      }
    } catch (error) {
      setState(() {
        errorMessage = authExceptionMessage(error.code);
      });
    }
  }
}
