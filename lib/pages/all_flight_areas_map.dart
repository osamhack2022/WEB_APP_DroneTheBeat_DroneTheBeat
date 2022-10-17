import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AllFlightAreasMap extends StatelessWidget {
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  Future addMarkerCircles() async {
    await FirebaseFirestore.instance
        .collection('flight_info')
        .where('accepted', whereIn: ['accepted'])
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              Marker newMarker = Marker(
                markerId: MarkerId(
                    'marker_id_${element.data()['location'].latitude}_${element.data()['location'].longitude}'),
                position: LatLng(element.data()['location'].latitude,
                    element.data()['location'].longitude),
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: const InfoWindow(
                  title: '주소',
                  snippet: '비행 반경',
                ),
              );
              Circle newCircle = Circle(
                circleId: CircleId(
                    'circle_id_${DateTime.now().millisecondsSinceEpoch}'),
                center: LatLng(element.data()['location'].latitude,
                    element.data()['location'].longitude),
                fillColor: Colors.blue.shade100.withOpacity(0.5),
                strokeColor: Colors.blue.shade100.withOpacity(0.1),
                radius: double.parse(element.data()['radius']),
              );
              _markers.add(newMarker);
              _circles.add(newCircle);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Flights'),
      ),
      body: FutureBuilder(
        future: addMarkerCircles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.5651, 126.98955),
              zoom: 16,
            ),
            markers: _markers,
            circles: _circles,
          );
        },
      ),
    );
  }
}
