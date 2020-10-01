import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/screens/map_screen.dart';
import 'package:parking/widgets/image_uploader.dart';
import 'package:parking/widgets/post_slot_form.dart';
import 'package:parking/widgets/primary_button.dart';
import 'package:uuid/uuid.dart';

class PostSlotScreen extends StatefulWidget {
  @override
  _PostSlotScreenState createState() => _PostSlotScreenState();
}

class _PostSlotScreenState extends State<PostSlotScreen> {
  StorageReference imgStorage = FirebaseStorage.instance.ref();
  String uuid = Uuid().v1();
  Position position;
  Position selectedPosition;
  String selectedLocation;
  String slotImage;
  List<Marker> markers = [];
  User user;
  bool selectImageReminder = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dailyController = TextEditingController();
  TextEditingController hourlyController = TextEditingController();
  GlobalKey<FormState> postSlotFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    selectedPosition = position;
    selectedLocation = 'Tap on map to select location...';
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      return Material(child: Center(child: Text("loading...")));
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add new slot'),
      ),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom < 1,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: GoogleMap(
                markers: Set.from(markers),
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                ),
                onTap: setPosition,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Visibility(
                        visible: selectedPosition != null,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: ImageUploader(
                          image: slotImage,
                          uploadImage: uploadImage,
                          selectImageReminder: selectImageReminder,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(selectedLocation),
                    ],
                  ),
                  Divider(),
                  PostSlotForm(
                    titleController: titleController,
                    descriptionController: descriptionController,
                    hourlyController: hourlyController,
                    dailyController: dailyController,
                    formKey: postSlotFormKey,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom < 1,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: PrimaryButton(
                  text: 'Add new parking slot',
                  onClick: postSlot,
                  color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }

  void getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      setState(() {
        this.position = position;
      });
    }
  }

  void setPosition(tappedPosition) {
    selectedPosition = Position(
      latitude: tappedPosition.latitude,
      longitude: tappedPosition.longitude,
    );
    setState(() {
      markers = [
        Marker(
          position:
              LatLng(selectedPosition.latitude, selectedPosition.longitude),
          markerId: MarkerId('CurrentSelectedLatLng'),
        )
      ];
      getLocation();
    });
  }

  void getLocation() async {
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(
        selectedPosition.latitude, selectedPosition.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      setState(() {
        selectedLocation = placemarks[0].thoroughfare +
            ', ' +
            placemarks[0].postalCode +
            ', ' +
            placemarks[0].locality;
      });
    }
  }

  void postSlot() {
    if (slotImage == null) {
      setState(() {
        selectImageReminder = true;
      });
    }
    if (postSlotFormKey.currentState.validate() && slotImage != null) {
      CollectionReference slotsDb =
          FirebaseFirestore.instance.collection('slots');
      slotsDb.doc(uuid).set({
        'title': titleController.text,
        'latitude': selectedPosition.latitude,
        'longitude': selectedPosition.longitude,
        'daily': dailyController.text,
        'hourly': hourlyController.text,
        'imageUrl': slotImage,
        'userUid': user.uid,
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MapScreen()));
    }
  }

  void uploadImage(pickedImage) async {
    String imageId = selectedPosition.latitude.toString() +
        '_' +
        position.longitude.toString();
    StorageUploadTask uploadTask =
        imgStorage.child(imageId).putFile(File(pickedImage.path));

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      slotImage = url;
      selectImageReminder = false;
    });
  }
}
