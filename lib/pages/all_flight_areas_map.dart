import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'flight_area_page.dart';

class AllFlightAreasMap extends StatefulWidget {
  @override
  State<AllFlightAreasMap> createState() => _AllFlightAreasMapState();
}

class _AllFlightAreasMapState extends State<AllFlightAreasMap> {
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  DateTime date = DateTime.now();
  DateFormat _dateFormat = DateFormat('y-MM-d H:mm');

  Future _addMarkerCircles() async {
    await FirebaseFirestore.instance
        .collection('flight_info')
        .where('accepted', whereIn: ['accepted'])
        /*.where('flightStart',
            isLessThanOrEqualTo:
                DateTime(date.year, date.month, date.day, 23, 59))
        .where('flightEnd',
            isGreaterThanOrEqualTo:
                DateTime(date.year, date.month, date.day, 0, 0))
        */
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
                infoWindow: InfoWindow(
                  title: '${element.data()['purpose']}',
                  snippet:
                      '${_dateFormat.format(element.data()['flightStart'].toDate())} ~ ${_dateFormat.format(element.data()['flightEnd'].toDate())}',
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
    DateFormat _dateFormat = DateFormat('y-MM-d');
    return Scaffold(
      appBar: AppBar(
        title: Text('전체 비행 조회'),
        actions: [
          TextButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2022),
                lastDate: DateTime(2030),
              );

              if (newDate == null) return;

              setState(() => date = newDate);
            },
            child: Text(
              _dateFormat.format(date),
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _addMarkerCircles().asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(36.6894, 126.5228),
              zoom: 14,
            ),
            markers: _markers,
            circles: _circles,
            polygons: polygons,
          );
        },
      ),
    );
  }
}
