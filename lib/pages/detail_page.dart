import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloworld/components/accept_icon.dart';
import 'package:intl/intl.dart';

import '../components/map_polygon_methods.dart';
import 'flight_area_page.dart';

class DetailPage extends StatelessWidget {
  final String docID;
  final String uid;

  const DetailPage({required this.docID, required this.uid});

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < polygonPoints.length; i++) {
      polygons.add(Polygon(
        polygonId:
            PolygonId('polygon_id_${DateTime.now().millisecondsSinceEpoch}'),
        points: polygonPoints[i],
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.red,
        geodesic: true,
        strokeWidth: 2,
      ));
    }

    DateFormat _dateFormat = DateFormat('y-MM-d H:mm');
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 35,
          height: 35,
          child: BackButton(color: Colors.black),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
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
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '비행 세부 정보',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          AcceptIcon(accepted: snapshot.data['accepted']),
                        ],
                      ),
                      SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '신청자 정보',
                            style: TextStyle(
                              color: Color(0xff797979),
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildRequesterInfo(),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '비행 정보',
                            style: TextStyle(
                              color: Color(0xff797979),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.gite_rounded),
                                  title: Text('허가부대'),
                                  subtitle: Text(snapshot.data['army']),
                                ),
                                Divider(height: 5),
                                ListTile(
                                  leading: Icon(Icons.keyboard_command_key),
                                  title: Text('기종'),
                                  subtitle: Text(snapshot.data['model']),
                                ),
                                Divider(height: 5),
                                ListTile(
                                  leading: Icon(Icons.calendar_month),
                                  title: Text('기간'),
                                  subtitle: Text(
                                      '${_dateFormat.format(snapshot.data['flightStart'].toDate())} ~ ${_dateFormat.format(snapshot.data['flightEnd'].toDate())}'),
                                ),
                                Divider(height: 5),
                                ListTile(
                                  leading: Icon(Icons.live_help),
                                  title: Text('목적'),
                                  subtitle: Text(snapshot.data['purpose']),
                                ),
                                Divider(height: 5),
                                Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.radar),
                                      title: Text('비행 반경'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 300,
                                        child: GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                snapshot
                                                    .data['location'].latitude,
                                                snapshot.data['location']
                                                    .longitude),
                                            zoom: 16,
                                          ),
                                          markers: {
                                            Marker(
                                              markerId: MarkerId(
                                                  'marker_id_${DateTime.now().millisecondsSinceEpoch}'),
                                              position: LatLng(
                                                  snapshot.data['location']
                                                      .latitude,
                                                  snapshot.data['location']
                                                      .longitude),
                                              icon: BitmapDescriptor
                                                  .defaultMarker,
                                              infoWindow: InfoWindow(
                                                title:
                                                    '${snapshot.data['purpose']}',
                                                snippet:
                                                    '${_dateFormat.format(snapshot.data['flightStart'].toDate())} ~ ${_dateFormat.format(snapshot.data['flightEnd'].toDate())}',
                                              ),
                                            ),
                                          },
                                          circles: {
                                            Circle(
                                              circleId: CircleId(
                                                  'circle_id_${DateTime.now().millisecondsSinceEpoch}'),
                                              center: LatLng(
                                                  snapshot.data['location']
                                                      .latitude,
                                                  snapshot.data['location']
                                                      .longitude),
                                              fillColor: Colors.blue.shade100
                                                  .withOpacity(0.5),
                                              strokeColor: Colors.blue.shade100
                                                  .withOpacity(0.1),
                                              radius: double.parse(
                                                  snapshot.data['radius']),
                                            ),
                                          },
                                          polygons: polygons,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      FirebaseAuth.instance.currentUser!.uid ==
                                  'jHBGhQtOR7YmWX3Zy1Bk08Yqp4y2' &&
                              snapshot.data['accepted'] == 'reviewing'
                          ? _buildAcceptButton(context)
                          : Container(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequesterInfo() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.account_box),
                title: Text('이름'),
                subtitle: Text(snapshot.data.docs[0]['name']),
              ),
              Divider(height: 5),
              ListTile(
                leading: Icon(Icons.cake),
                title: Text('생년월일'),
                subtitle: Text(
                    snapshot.data.docs[0]['birthday'].substring(0, 4) +
                        '-' +
                        snapshot.data.docs[0]['birthday'].substring(4, 6) +
                        '-' +
                        snapshot.data.docs[0]['birthday'].substring(6)),
              ),
              Divider(height: 5),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('전화번호'),
                subtitle: Text(snapshot.data.docs[0]['phoneNumber']),
              ),
              Divider(height: 5),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('flight_info')
                  .doc(docID)
                  .update({'accepted': 'accepted'});
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.check),
                SizedBox(width: 3),
                Text('승인'),
              ],
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('flight_info')
                  .doc(docID)
                  .update({'accepted': 'declined'});
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.close),
                SizedBox(width: 3),
                Text('반려'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
