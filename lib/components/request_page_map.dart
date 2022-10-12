import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../pages/flight_area_page.dart';

class RequestPageMap extends StatefulWidget {
  _RequestPageMapState createState() => _RequestPageMapState();
}

class _RequestPageMapState extends State<RequestPageMap> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 16,
        ),
        markers: markers,
      ),
    );
  }
}
