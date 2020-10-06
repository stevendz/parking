import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/main.dart';
import 'package:parking/screens/auth_screen.dart';
import 'package:parking/screens/splash_screen.dart';
import 'package:parking/widgets/primary_button.dart';

class WelcomeBackScreen extends StatefulWidget {
  @override
  _WelcomeBackScreenState createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  static CollectionReference usersDb =
      FirebaseFirestore.instance.collection('users');
  User user = FirebaseAuth.instance.currentUser;

  void initState() {
    resetGuestAccess();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: usersDb.doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          var username = snapshot.data.data() != null
              ? snapshot.data.data()['username']
              : 'null';
          return Scaffold(
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
                            Color(0xff795EB7), BlendMode.multiply),
                        fit: BoxFit.cover),
                  ),
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 75),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/parking-41df9.appspot.com/o/logo_light.png?alt=media',
                              fit: BoxFit.cover,
                              width: 75,
                              height: 75,
                            ),
                            Text(
                              'parking',
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: -3,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Spacer(),
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 35),
                        PrimaryButton(
                          text: 'continue as '.toUpperCase() +
                              username.toUpperCase(),
                          onClick: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthScreen(),
                              ),
                            );
                          },
                          big: true,
                        ),
                        SizedBox(height: 35),
                        FlatButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ),
                            );
                          },
                          child: Text(
                            'Not $username? Login now.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> resetGuestAccess() async {
    if (user.isAnonymous) {
      await FirebaseAuth.instance.signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    }
  }
}
