import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class PostSlotScreen extends StatefulWidget {
  @override
  _PostSlotScreenState createState() => _PostSlotScreenState();
}

class _PostSlotScreenState extends State<PostSlotScreen> {
  Position position;
  Position selectedPosition;
  String selectedLocation = 'Tap on map to select location...';
  String slotImage;
  List<Marker> markers = [];

  initState() {
    super.initState();
    getPosition();
  }

  getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      setState(() {
        this.position = position;
      });
    }
  }

  setMarker() {
    setState(() {
      markers = [];
      markers.add(
        Marker(
          position:
              LatLng(selectedPosition.latitude, selectedPosition.longitude),
          markerId: MarkerId('CurrentSelectedLatLng'),
        ),
      );
      getLocation();
    });
  }

  getLocation() async {
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(
        selectedPosition.latitude, selectedPosition.longitude);
    setState(() {
      selectedLocation = placemarks[0].thoroughfare +
          ', ' +
          placemarks[0].postalCode +
          ', ' +
          placemarks[0].locality;
    });
  }

  setSlotImage(url) {
    setState(() {
      slotImage = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    StorageReference imgStorage = FirebaseStorage.instance.ref();
    if (position == null) {
      return Material(child: Center(child: Text("loading...")));
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add new slot'),
        ),
        body: Column(
          children: <Widget>[
            MediaQuery.of(context).viewInsets.bottom > 1
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GoogleMap(
                      markers: Set.from(markers),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 14,
                      ),
                      onTap: (position) {
                        selectedPosition = Position(
                          latitude: position.latitude,
                          longitude: position.longitude,
                        );
                        setMarker();
                      },
                    ),
                  ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            PickedFile pickedImage = await ImagePicker()
                                .getImage(source: ImageSource.gallery);
                            String imageId = position.latitude.toString() +
                                '_' +
                                position.longitude.toString();
                            imgStorage
                                .child(imageId)
                                .putFile(File(pickedImage.path));

                            imgStorage
                                .child(imageId)
                                .getDownloadURL()
                                .then((url) => setSlotImage(url));
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: slotImage == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    color: Colors.grey,
                                  )
                                : Image.network(slotImage),
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(selectedLocation),
                      ],
                    ),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(helperText: 'Description'),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              helperText: 'Daily',
                              suffixIcon: Icon(Icons.attach_money),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              helperText: 'Hourly',
                              suffixIcon: Icon(Icons.attach_money),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
