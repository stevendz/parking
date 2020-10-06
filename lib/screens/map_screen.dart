import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/widgets/fab_menu.dart';
import 'package:parking/widgets/please_login_alert.dart';
import 'package:parking/widgets/slot_alert_dialog.dart';
import 'package:google_maps_webservice/places.dart';
import '../credentials.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position position;
  User user = FirebaseAuth.instance.currentUser;
  List<Marker> markers = [];
  GoogleMapController mapController;
  CollectionReference slotsDb = FirebaseFirestore.instance.collection('slots');
  CollectionReference usersDb = FirebaseFirestore.instance.collection('users');
  GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  bool isLoading = false;
  bool isGuest = true;

  @override
  void initState() {
    super.initState();
    preloadData();
  }

  preloadData() async {
    isLoading = true;
    Position newPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (newPosition != null) {
      await loadSlots();
      setState(() {
        position = newPosition;
      });
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    isGuest = user.isAnonymous;
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                'https://firebasestorage.googleapis.com/v0/b/parking-41df9.appspot.com/o/logo_light.png?alt=media',
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
              Text(
                'parking',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: -3),
              ),
            ],
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
            zoom: 12,
          ),
        ),
        floatingActionButton: FabMenu(
          moveToLocation: moveToLocation,
          searchLocation: searchLocation,
          noAccess: noAccess,
          isGuest: isGuest,
        ),
      );
    }
  }

  Future<void> searchLocation() async {
    Prediction prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: "de",
      logo: Container(),
      components: [Component(Component.country, "de")],
    );
    if (prediction != null) {
      PlacesDetailsResponse details =
          await places.getDetailsByPlaceId(prediction.placeId);
      if (details != null) {
        Position location = Position(
          latitude: details.result.geometry.location.lat,
          longitude: details.result.geometry.location.lng,
        );
        moveToLocation(location);
      }
    }
  }

  noAccess() {
    showDialog(context: context, builder: (context) => PleaseLoginDialog());
  }

  loadSlots() async {
    await slotsDb.get().then(
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

  moveToLocation(newLocation) async {
    if (newLocation != null) {
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 14,
            target: LatLng(
              newLocation.latitude,
              newLocation.longitude,
            ),
          ),
        ),
      );
      setState(() {
        position = newLocation;
      });
    }
  }
}
