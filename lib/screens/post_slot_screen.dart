import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PostSlotScreen extends StatefulWidget {
  @override
  _PostSlotScreenState createState() => _PostSlotScreenState();
}

class _PostSlotScreenState extends State<PostSlotScreen> {
  String uuid = Uuid().v1();
  Position position;
  Position selectedPosition;
  String selectedLocation;
  String slotImage;
  List<Marker> markers = [];
  User user;

  // Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dailyController = TextEditingController();
  TextEditingController hourlyController = TextEditingController();

  initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    selectedPosition = position;
    selectedLocation = 'Tap on map to select location...';
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

  postSlot() {
    // TODO: Add validation
    CollectionReference slotsDb =
        FirebaseFirestore.instance.collection('slots');
    slotsDb.doc(uuid).set({
      'title': titleController.text,
      'latitude': selectedPosition.latitude,
      'longitude': selectedPosition.longitude,
      'daily': dailyController.text,
      'hourly': hourlyController.text,
      'imageUrl': slotImage,
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
                    height: MediaQuery.of(context).size.height * 0.3,
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
                            String imageId =
                                selectedPosition.latitude.toString() +
                                    '_' +
                                    position.longitude.toString();
                            StorageUploadTask uploadTask = imgStorage
                                .child(imageId)
                                .putFile(File(pickedImage.path));

                            String url = await (await uploadTask.onComplete)
                                .ref
                                .getDownloadURL();
                            setState(() {
                              slotImage = url;
                            });
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
                      controller: titleController,
                      decoration: InputDecoration(helperText: 'Title'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(helperText: 'Description'),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: hourlyController,
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
                            controller: dailyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              helperText: 'Hourly',
                              suffixIcon: Icon(Icons.attach_money),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            FlatButton(
              onPressed: postSlot,
              child: Text('Post parking slot'),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      );
    }
  }
}
