import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final String docID;

  const DetailPage({required this.docID});

  @override
  Widget build(BuildContext context) {
    DateFormat _dateFormat = DateFormat('y-MM-d H:mm');
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('flight_info')
                .doc(docID)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return Column(
                children: [
                  Text(snapshot.data['army']),
                  Text(snapshot.data['model']),
                  Text(_dateFormat.format(snapshot.data['duration'].toDate())),
                  Text(snapshot.data['purpose']),
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(snapshot.data['location'].latitude,
                            snapshot.data['location'].longitude),
                        zoom: 16,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(
                              'marker_id_${DateTime.now().millisecondsSinceEpoch}'),
                          position: LatLng(snapshot.data['location'].latitude,
                              snapshot.data['location'].longitude),
                          icon: BitmapDescriptor.defaultMarker,
                          infoWindow: const InfoWindow(
                            title: '주소',
                            snippet: '비행 반경',
                          ),
                        ),
                      },
                      circles: {
                        Circle(
                          circleId: CircleId(
                              'circle_id_${DateTime.now().millisecondsSinceEpoch}'),
                          center: LatLng(snapshot.data['location'].latitude,
                              snapshot.data['location'].longitude),
                          fillColor: Colors.blue.shade100.withOpacity(0.5),
                          strokeColor: Colors.blue.shade100.withOpacity(0.1),
                          radius: double.parse(snapshot.data['radius']),
                        ),
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 10),
          if (FirebaseAuth.instance.currentUser!.uid ==
              'jHBGhQtOR7YmWX3Zy1Bk08Yqp4y2')
            _buildAcceptButton(context),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('flight_info')
                .doc(docID)
                .update({'accepted': 'accepted'});
            Navigator.pop(context);
          },
          child: Text('승인'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('flight_info')
                .doc(docID)
                .update({'accepted': 'declined'});
            Navigator.pop(context);
          },
          child: Text('반려'),
        ),
      ],
    );
  }
}
