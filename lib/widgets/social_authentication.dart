import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parking/screens/map_screen.dart';
import 'package:parking/widgets/primary_button.dart';

class SocialAuthentication extends StatelessWidget {
  const SocialAuthentication({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'or continue with',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: PrimaryButton(
                text: 'Google',
                onClick: () {
                  signUpInWithGoogle(context);
                },
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: PrimaryButton(
                text: 'Guest',
                onClick: () {
                  signUpAsGuest(context);
                },
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> signUpAsGuest(context) async {
    UserCredential user = await FirebaseAuth.instance.signInAnonymously();
    if (user != null) {
      print(user);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MapScreen()));
    }
  }

  Future<void> signUpInWithGoogle(context) async {
    CollectionReference usersDb =
        FirebaseFirestore.instance.collection('users');
    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();
    if (googleSignInAccount == null) return;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    if (googleSignInAccount == null) return;
    final GoogleAuthCredential googleAuthCredential =
        GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
    if (googleAuthCredential == null) return;
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);
    if (user != null) {
      var userDB = await usersDb.doc(user.user.uid).get();
      if (!userDB.exists) {
        usersDb.doc(user.user.uid).set({
          'username': googleSignInAccount.displayName,
          'avatarUrl': googleSignInAccount.photoUrl
        });
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MapScreen()));
    }
  }
}
