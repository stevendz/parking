import 'package:flutter/material.dart';
import 'package:parking/screens/auth_screen.dart';
import 'package:parking/widgets/primary_button_border.dart';
import 'package:parking/widgets/primary_button.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  colorFilter:
                      ColorFilter.mode(Color(0xff795EB7), BlendMode.multiply),
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
                  PrimaryButtonBorder(
                    text: 'Sign Up'.toUpperCase(),
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthScreen(isSignUp: true),
                        ),
                      );
                    },
                    big: true,
                  ),
                  SizedBox(height: 35),
                  PrimaryButton(
                    text: 'login'.toUpperCase(),
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthScreen(),
                        ),
                      );
                    },
                    big: true,
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
}
