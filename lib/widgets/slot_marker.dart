import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SlotMarker extends StatefulWidget {
  final Map slot;

  const SlotMarker({Key key, this.slot}) : super(key: key);

  @override
  _SlotMarkerState createState() => _SlotMarkerState();
}

class _SlotMarkerState extends State<SlotMarker> {
  String location = '';
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

  @override
  void initState() {
    getLocation();
    super.initState();
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
                image: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/parking-41df9.appspot.com/o/slot.jpg?alt=media&token=1015cf8b-0613-4c0d-b42d-df7341a0ee5f'),
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
