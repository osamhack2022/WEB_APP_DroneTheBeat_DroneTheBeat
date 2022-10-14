import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailPage extends StatelessWidget {
  final String docID;

  const DetailPage({required this.docID});

  @override
  Widget build(BuildContext context) {
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
                  Text(snapshot.data['duration']),
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
                .update({'accepted': true});
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
                .update({'accepted': false});
            Navigator.pop(context);
          },
          child: Text('반려'),
        ),
      ],
    );
  }
}
