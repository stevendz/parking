import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SlotAlertDialog extends StatefulWidget {
  final Map slot;

  const SlotAlertDialog({Key key, this.slot}) : super(key: key);

  @override
  _SlotAlertDialogState createState() => _SlotAlertDialogState();
}

class _SlotAlertDialogState extends State<SlotAlertDialog> {
  String userAvatar;
  String location = '';

  @override
  void initState() {
    super.initState();
    getLocation();
    getUserAvatar();
  }

  getLocation() async {
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(
        widget.slot["latitude"], widget.slot["longitude"]);
    setState(() {
      location = placemarks[0].thoroughfare +
          ', ' +
          placemarks[0].postalCode +
          ', ' +
          placemarks[0].locality;
    });
  }

  getUserAvatar() async {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
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
                    : 'https://d27p8o2qkwv41j.cloudfront.net/wp-content/uploads/2018/09/shutterstock_1053846248-e1537260333858.jpg'),
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
                        ? (widget.slot["hourly"].toString() + '€')
                        : '-'),
              ),
              Text(
                'daily: ' +
                    (widget.slot["daily"] != null
                        ? (widget.slot["daily"].toString() + '€')
                        : '-'),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () {},
                child: Text('Book'),
                color: Theme.of(context).primaryColor,
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Contact'),
                color: Theme.of(context).primaryColorLight,
              )
            ],
          )
        ],
      ),
    );
  }
}
