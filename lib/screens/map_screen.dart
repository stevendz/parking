import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/widgets/fab_menu.dart';
import 'package:parking/widgets/slot_alert_dialog.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position position;
  User user;
  String username;
  bool isSearching = false;
  List<Marker> markers = [];
  GoogleMapController mapController;
  CollectionReference slotsDb = FirebaseFirestore.instance.collection('slots');
  CollectionReference usersDb = FirebaseFirestore.instance.collection('users');

  initState() {
    super.initState();
    //Random position for debugging
    position = Position(
      latitude: 58.5638133,
      longitude: 18.0425983,
    );
    user = FirebaseAuth.instance.currentUser;
    loadSlots();
    getUsername();
  }

  loadSlots() {
    slotsDb.get().then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (slot) {
                markers.add(
                  Marker(
                    markerId: MarkerId(slot.id),
                    position: LatLng(
                      slot.data()["latitude"],
                      slot.data()["longitude"],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => SlotAlertDialog(
                          slot: slot.data(),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          },
        );
  }

  moveToLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (position != null) {
        setState(() {
          this.position = position;
        });
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 14,
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  getUsername() async {
    String username = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value.data()['username']);
    setState(() {
      this.username = username;
    });
  }

  toggleSearchbar() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: isSearching
            ? TextFormField(autofocus: true)
            : Text(
                'Hello ' + (username != null ? username : 'No User'),
              ),
        leading: isSearching ? Icon(Icons.search) : Container(),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: toggleSearchbar,
                )
              : Container()
        ],
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: Set.from(markers),
        onLongPress: (argument) {
          print(argument);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
      ),
      floatingActionButton: FabMenu(
        moveToLocation: moveToLocation,
        toggleSearchbar: toggleSearchbar,
      ),
    );
  }
}
