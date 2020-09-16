import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostSlotScreen extends StatefulWidget {
  @override
  _PostSlotScreenState createState() => _PostSlotScreenState();
}

class _PostSlotScreenState extends State<PostSlotScreen> {
  Position position;
  Position selectedPosition;
  List<Marker> markers = [];

  initState() {
    super.initState();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return position == null
        ? Material(child: Center(child: Text("loading...")))
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Add new slot'),
            ),
            body: ListView(
              children: <Widget>[
                MediaQuery.of(context).viewInsets.bottom > 1
                    ? Container()
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: GoogleMap(
                          markers: Set.from(markers),
                          initialCameraPosition: CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
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
                TextFormField(),
              ],
            ),
          );
  }
}
