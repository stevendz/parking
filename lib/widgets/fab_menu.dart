import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking/screens/auth_screen.dart';

class FabMenu extends StatelessWidget {
  final Function getLocation;
  const FabMenu({
    Key key,
    @required this.getLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
      alignment: Alignment.bottomLeft,
      ringColor: Colors.black.withAlpha(25),
      ringDiameter: 300.0,
      ringWidth: 60,
      fabSize: 50.0,
      fabColor: Theme.of(context).primaryColor,
      fabOpenIcon: Icon(Icons.menu, color: Colors.black),
      fabCloseIcon: Icon(Icons.close, color: Colors.black),
      children: <Widget>[
        RawMaterialButton(
          elevation: 0,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Get.off(AuthScreen());
          },
          fillColor: Theme.of(context).primaryColorLight,
          shape: CircleBorder(),
          child: Icon(Icons.person),
        ),
        RawMaterialButton(
          elevation: 0,
          onPressed: () {},
          fillColor: Theme.of(context).primaryColorLight,
          shape: CircleBorder(),
          child: Icon(Icons.chat),
        ),
        RawMaterialButton(
          elevation: 0,
          onPressed: () {},
          fillColor: Theme.of(context).primaryColorLight,
          shape: CircleBorder(),
          child: Icon(Icons.search),
        ),
        RawMaterialButton(
          elevation: 0,
          onPressed: getLocation,
          fillColor: Theme.of(context).primaryColorLight,
          shape: CircleBorder(),
          child: Icon(Icons.room),
        ),
      ],
    );
  }
}
