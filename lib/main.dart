import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking',
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position position = Position(latitude: 58.5638133, longitude: 18.0425983);
  String locationText = 'Please choose location...';
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
        print(position);
        List<Placemark> placemarks = await Geolocator()
            .placemarkFromCoordinates(position.latitude, position.longitude);
        setState(() {
          locationText = placemarks[0].locality + ', ' + placemarks[0].country;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [
      Marker(
          markerId: MarkerId('slot1'),
          position: LatLng(53.5644297, 10.0502048),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('slot1'),
                // actions: [
                //   IconButton(
                //     icon: Icon(Icons.bookmark_border),
                //     onPressed: () {},
                //   ),
                //   IconButton(
                //     icon: Icon(Icons.beenhere),
                //     onPressed: () {},
                //   ),
                // ],
              ),
            );
          }),
      Marker(
          markerId: MarkerId('slot2'),
          position: LatLng(53.5694297, 10.0602048),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('slot2'),
              ),
            );
          }),
      Marker(
          markerId: MarkerId('slot3'),
          position: LatLng(53.5584297, 10.0552048),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('slot3'),
              ),
            );
          }),
      Marker(
          markerId: MarkerId('slot4'),
          position: LatLng(53.5554297, 10.0352048),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('slot4'),
              ),
            );
          }),
    ];
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: FlatButton(
                child: Text(locationText),
                onPressed: getLocation,
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                markers: Set.from(markers),
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                ),
              ),
            ),
          ],
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
