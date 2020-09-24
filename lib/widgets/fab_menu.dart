import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parking/screens/chat_screen.dart';
import 'package:parking/screens/my_chats_screen.dart';
import 'package:parking/screens/profile_screen.dart';

class FabMenu extends StatelessWidget {
  final Function moveToLocation;
  final Function searchLocation;
  const FabMenu({
    Key key,
    @required this.moveToLocation,
    @required this.searchLocation,
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
          onPressed: () {
            Get.to(ProfileScreen());
          },
          fillColor: Theme.of(context).primaryColorLight,
          shape: CircleBorder(),
          child: Icon(Icons.person),
        ),
        RawMaterialButton(
          elevation: 0,
          onPressed: () {
            Get.to(MyChatsScreen());
          },
          fillColor: Theme.of(context).primaryColorLight,
          shape: CircleBorder(),
          child: Icon(Icons.chat),
        ),
        RawMaterialButton(
          elevation: 0,
          onPressed: searchLocation,
          fillColor: Theme.of(context).primaryColorLight,
          shape: CircleBorder(),
          child: Icon(Icons.search),
        ),
        RawMaterialButton(
          elevation: 0,
          onPressed: () async {
            await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
                .then(
                  (position) => moveToLocation(position),
                );
          },
          fillColor: Theme.of(context).primaryColorLight,
          shape: CircleBorder(),
          child: Icon(Icons.room),
        ),
      ],
    );
  }
}
