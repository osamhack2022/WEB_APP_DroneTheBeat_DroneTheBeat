import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloworld/components/custom_text_field.dart';
import 'package:helloworld/components/request_page_map.dart';
import 'package:helloworld/pages/flight_area_page.dart';

import 'package:helloworld/styles.dart';

class FlightRequestPage extends StatefulWidget {
  @override
  State<FlightRequestPage> createState() => _FlightRequestPageState();
}

class _FlightRequestPageState extends State<FlightRequestPage> {
  final controllerArmy = TextEditingController();

  final controllerModel = TextEditingController();

  final controllerDuration = TextEditingController();

  final controllerPurpose = TextEditingController();

  Future<void> moveToNewLocation() async {
    LatLng newPostion = LatLng(markers.elementAt(0).position.latitude,
        markers.elementAt(0).position.longitude);
    requestPageGoogleMapController
        .animateCamera(CameraUpdate.newLatLng(newPostion));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text(
            "드론 비행 허가 신청",
            style: h5(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          CustomTextField(
            prefixText: "비행 허가 요청 부대",
            hintText: "",
            controller: controllerArmy,
          ),
          CustomTextField(
            prefixText: "드론 기종",
            hintText: "",
            controller: controllerModel,
          ),
          CustomTextField(
            prefixText: "기간",
            hintText: "",
            controller: controllerDuration,
          ),
          CustomTextField(
            prefixText: "비행 목적",
            hintText: "",
            controller: controllerPurpose,
          ),
          RequestPageMap(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FlightAreaPage()),
              ).then((value) {
                setState(() {
                  moveToNewLocation();
                });
              });
            },
            child: Text("비행반경 설정"),
          ),
          _buildElevatedButton(),
        ],
      ),
    );
  }

  Widget _buildElevatedButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          final String uid = FirebaseAuth.instance.currentUser!.uid;
          final String army = controllerArmy.text;
          final String model = controllerModel.text;
          final String duration = controllerDuration.text;
          final String purpose = controllerPurpose.text;
          final String radius = controllerDistance.text;
          final GeoPoint location = GeoPoint(
              markers.elementAt(0).position.latitude,
              markers.elementAt(0).position.longitude);
          final bool accepted = false;

          createRequest(
              uid: uid,
              army: army,
              model: model,
              duration: duration,
              purpose: purpose,
              radius: radius,
              location: location,
              accepted: accepted);

          Navigator.pop(context);
        },
        child: Text("신청"),
      ),
    );
  }

  Future createRequest({
    required String uid,
    required String army,
    required String model,
    required String duration,
    required String purpose,
    required String radius,
    required GeoPoint location,
    required bool accepted,
  }) async {
    final docRequest =
        FirebaseFirestore.instance.collection('flight_info').doc();

    final json = {
      'uid': uid,
      'army': army,
      'model': model,
      'duration': duration,
      'purpose': purpose,
      'radius': radius,
      'location': location,
      'accepted': accepted,
    };

    await docRequest.set(json);
  }
}
