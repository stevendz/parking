import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/widgets/image_uploader.dart';
import 'package:parking/widgets/post_slot_form.dart';

class EditSlotScreen extends StatefulWidget {
  final slot;

  const EditSlotScreen({
    Key key,
    this.slot,
  }) : super(key: key);
  @override
  _EditSlotScreenState createState() => _EditSlotScreenState();
}

class _EditSlotScreenState extends State<EditSlotScreen> {
  StorageReference imgStorage = FirebaseStorage.instance.ref();
  var slotData;
  List<Marker> position = [];
  String slotImage;
  String location = '';
  bool selectImageReminder = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dailyController = TextEditingController();
  TextEditingController hourlyController = TextEditingController();
  GlobalKey<FormState> postSlotFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    preloadSlotData();
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
                markers: Set.from(position),
                initialCameraPosition: CameraPosition(
                  target: LatLng(slotData['latitude'], slotData['longitude']),
                  zoom: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ImageUploader(
                        image: slotImage,
                        uploadImage: uploadImage,
                        selectImageReminder: selectImageReminder,
                      ),
                      SizedBox(width: 20),
                      Text(location),
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
          FlatButton(
            onPressed: postSlot,
            child: Text('Save changes'),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  void preloadSlotData() {
    slotData = widget.slot.data();
    slotImage = slotData['imageUrl'];
    titleController.text = slotData['title'];
    dailyController.text = slotData['daily'];
    hourlyController.text = slotData['hourly'];
    descriptionController.text = slotData['description'];
    getLocation();
    position.add(
      Marker(
        markerId: MarkerId(slotData['latitude'].toString()),
        position: LatLng(
          slotData['latitude'],
          slotData['longitude'],
        ),
      ),
    );
  }

  void getLocation() async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(slotData['latitude'], slotData['longitude']);
    if (placemarks != null && placemarks.isNotEmpty) {
      setState(() {
        location = placemarks[0].thoroughfare +
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
      slotsDb.doc(widget.slot.id).update({
        'title': titleController.text,
        'daily': dailyController.text,
        'hourly': hourlyController.text,
        'imageUrl': slotImage,
      });
      Get.back();
    }
  }

  void uploadImage(pickedImage) async {
    String imageId = slotData['position'].toString();
    StorageUploadTask uploadTask =
        imgStorage.child(imageId).putFile(File(pickedImage.path));

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      slotImage = url;
      selectImageReminder = false;
    });
  }
}
