import 'package:flutter/material.dart';
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

class HomePage extends StatelessWidget {
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
    return Container(
      child: GoogleMap(
        markers: Set.from(markers),
        initialCameraPosition: CameraPosition(
          target: LatLng(53.5644297, 10.0502048),
          zoom: 14,
        ),
      ),
    );
  }
}
