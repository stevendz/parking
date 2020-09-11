import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/widgets/slot_marker.dart';

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
                      slot.data()["latitude"],
                      slot.data()["longitude"],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => SlotMarker(slot: slot.data()),
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

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(user != null ? user.email : 'Guest'),
          leading:
              IconButton(icon: Icon(Icons.gps_fixed), onPressed: getLocation),
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
        floatingActionButton: Builder(
          builder: (context) => FabCircularMenu(
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
                onPressed: () {},
                fillColor: Theme.of(context).primaryColorLight,
                shape: CircleBorder(),
                child: Icon(Icons.person),
              ),
              RawMaterialButton(
                elevation: 0,
                onPressed: () {},
                fillColor: Theme.of(context).primaryColorLight,
                shape: CircleBorder(),
                child: Icon(Icons.chat),
              ),
              RawMaterialButton(
                elevation: 0,
                onPressed: () {},
                fillColor: Theme.of(context).primaryColorLight,
                shape: CircleBorder(),
                child: Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
