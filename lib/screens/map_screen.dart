import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position position = Position(
      latitude: 58.5638133,
      longitude: 18.0425983); //Random position for debugging
  User user;
  List<Marker> markers = [];
  CollectionReference slots = FirebaseFirestore.instance.collection('slots');

  initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    loadSlots();
  }

  loadSlots() {
    slots.get().then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (slot) {
                markers.add(
                  Marker(
                    markerId: MarkerId(slot.id),
                    position: LatLng(
                        slot.data()["latitude"], slot.data()["longitude"]),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(slot.data()["title"]),
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

  getLocation() async {
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

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(user != null ? user.email : 'Guest'),
        ),
        body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          markers: Set.from(markers),
          initialCameraPosition: CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.gps_fixed),
          onPressed: getLocation,
        ),
      ),
    );
  }
}
