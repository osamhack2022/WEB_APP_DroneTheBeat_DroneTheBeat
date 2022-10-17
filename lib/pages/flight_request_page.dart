import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloworld/components/custom_text_field.dart';
import 'package:helloworld/components/request_page_map.dart';
import 'package:helloworld/pages/flight_area_page.dart';

import 'package:helloworld/styles.dart';

const List<String> armyList = <String>[
  '제1전투비행단',
  '제3전투비행단',
  '제5전투비행단',
  '제8전투비행단',
  '제10전투비행단',
  '제15특수임무비행단',
  '제16전투비행단',
  '제17전투비행단',
  '제18전투비행단',
  '제19전투비행단',
  '제20전투비행단',
];

const List<String> modelList = <String>[
  'DJI SPARK',
  'DJI MAVIC AIR',
  'PARROT ANAFI',
];

class FlightRequestPage extends StatefulWidget {
  @override
  State<FlightRequestPage> createState() => _FlightRequestPageState();
}

class _FlightRequestPageState extends State<FlightRequestPage> {
  String dropdownValueArmy = armyList.first;
  String dropdownValueModel = modelList.first;
  final controllerModel = TextEditingController();
  DateTime flightDateTime = DateTime(2022);
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
          _buildDropdownButton('허가 요청 부대', dropdownValueArmy, armyList),
          SizedBox(height: 15),
          _buildDropdownButton('드론 기종', dropdownValueModel, modelList),
          _buildDateTimePicker(),
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

  Widget _buildDropdownButton(
      String title, String dropdownValueContext, List dropdownList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: overLine(),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: DropdownButton<String>(
              value: dropdownValueContext,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValueContext = value!;
                });
              },
              items: dropdownList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '비행 기간',
              style: overLine(),
            ),
          ),
          SizedBox(height: 5),
          TextButton(
              onPressed: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(2022, 1, 1, 00, 00),
                  maxTime: DateTime(2023, 12, 31, 23, 59),
                  onConfirm: (date) {
                    flightDateTime = date;
                  },
                  locale: LocaleType.ko,
                );
              },
              child: Text(
                '기간을 설정하세요',
                style: TextStyle(color: Colors.blue),
              )),
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
          final String army = dropdownValueArmy;
          final String model = dropdownValueModel;
          final DateTime duration = flightDateTime;
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
    required DateTime duration,
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
