import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking/screens/chat_screen.dart';
import 'package:parking/widgets/primary_button.dart';
import 'package:parking/widgets/primary_button_border.dart';

class SlotAlertDialog extends StatefulWidget {
  final Map slot;

  const SlotAlertDialog({Key key, this.slot}) : super(key: key);

  @override
  _SlotAlertDialogState createState() => _SlotAlertDialogState();
}

class _SlotAlertDialogState extends State<SlotAlertDialog> {
  String userAvatar;
  String location;
  User user;

  @override
  void initState() {
    super.initState();
    getLocation();
    getUserAvatar();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return location == null
        ? Center(
            child: Material(
              child: Container(
                padding: EdgeInsets.all(50),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  'Something went wrong, please check your connection and try again.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        : AlertDialog(
            contentPadding: EdgeInsets.all(10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      backgroundImage:
                          userAvatar != null ? NetworkImage(userAvatar) : null,
                    ),
                    SizedBox(width: 10),
                    Expanded(child: Text(location)),
                    GestureDetector(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.slot['imageUrl'] != null
                          ? widget.slot['imageUrl']
                          : 'https://firebasestorage.googleapis.com/v0/b/parking-41df9.appspot.com/o/slot.jpg?alt=media'),
                    ),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'hourly: ' +
                          (widget.slot["hourly"] != null
                              ? (widget.slot["hourly"].toString() + '\$')
                              : '-'),
                    ),
                    Text(
                      'daily: ' +
                          (widget.slot["daily"] != null
                              ? (widget.slot["daily"].toString() + '\$')
                              : '-'),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryButton(
                      onClick:
                          user.uid != widget.slot['userUid'] ? () {} : null,
                      text: 'Book',
                      color: Theme.of(context).primaryColor,
                    ),
                    PrimaryButtonBorder(
                      onClick: user.uid != widget.slot['userUid']
                          ? () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatPartner: widget.slot['userUid'],
                                    object: location,
                                  ),
                                ),
                              );
                            }
                          : null,
                      text: 'Contact',
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                )
              ],
            ),
          );
  }

  void getLocation() async {
    try {
      List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(
          widget.slot["latitude"], widget.slot["longitude"]);
      if (placemarks != null) {
        setState(() {
          location = placemarks[0].thoroughfare +
              ', ' +
              placemarks[0].postalCode +
              ', ' +
              placemarks[0].locality;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void getUserAvatar() async {
    String userUid = widget.slot['userUid'];
    String url = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .get()
        .then((value) => value.data()['avatarUrl']);
    setState(() {
      userAvatar = url;
    });
  }
}
