import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/widgets/fab_menu.dart';
import 'package:parking/widgets/slot_alert_dialog.dart';
import 'package:google_maps_webservice/places.dart';
import '../credentials.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position position;
  User user;
  String username;
  List<Marker> markers = [];
  GoogleMapController mapController;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  CollectionReference slotsDb = FirebaseFirestore.instance.collection('slots');
  CollectionReference usersDb = FirebaseFirestore.instance.collection('users');
  GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Hello ' + (username != null ? username : 'No User'),
        ),
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
        searchLocation: searchLocation,
      ),
    );
  }

  Future<void> searchLocation() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: "de",
      logo: Container(),
      components: [Component(Component.country, "de")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(
      Prediction prediction, ScaffoldState scaffold) async {
    if (prediction != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse position =
          await places.getDetailsByPlaceId(prediction.placeId);
      final lat = position.result.geometry.location.lat;
      final lng = position.result.geometry.location.lng;
      print(lat);
    }
  }

  void loadSlots() {
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

  void moveToLocation(newPosition) async {
    if (newPosition != null) {
      setState(() {
        this.position = newPosition;
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
      return;
    }
    print('No Location');
  }

  void getUsername() async {
    String username = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => value.data()['username']);
    setState(() {
      this.username = username;
    });
  }
}
