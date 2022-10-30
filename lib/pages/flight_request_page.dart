import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloworld/components/custom_dropdown_button.dart';
import 'package:helloworld/components/custom_text_field.dart';
import 'package:helloworld/components/request_page_map.dart';
import 'package:helloworld/pages/flight_area_page.dart';

import 'package:helloworld/styles.dart';
import 'package:intl/intl.dart';

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

String dropdownValueArmy = armyList.first;
String dropdownValueModel = modelList.first;

class FlightRequestPage extends StatefulWidget {
  @override
  State<FlightRequestPage> createState() => _FlightRequestPageState();
}

class _FlightRequestPageState extends State<FlightRequestPage> {
  final controllerModel = TextEditingController();
  DateTime? flightDateTimeStart;
  DateTime? flightDateTimeEnd;
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ListView(
            children: [
              Text(
                "드론 비행 허가 신청",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    CustomDropdownButton(
                        title: '허가 요청 부대', dropdownList: armyList),
                    Divider(height: 10),
                    CustomDropdownButton(
                        title: '드론 기종', dropdownList: modelList),
                    Divider(height: 10),
                    _buildDateTimePicker(),
                    Divider(height: 10),
                    CustomTextField(
                      prefixText: "비행 목적",
                      hintText: "",
                      controller: controllerPurpose,
                    ),
                    Divider(height: 10),
                    RequestPageMap(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FlightAreaPage()),
                        ).then((value) {
                          setState(() {
                            moveToNewLocation();
                          });
                        });
                      },
                      child: Text("비행반경 설정"),
                    ),
                  ],
                ),
              ),
              _buildElevatedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    DateFormat _dateFormat = DateFormat('y-MM-d H:mm');
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2023, 12, 31, 23, 59),
                      onConfirm: (date) {
                        flightDateTimeStart = date;
                        setState(() {});
                      },
                      locale: LocaleType.ko,
                    );
                  },
                  child: flightDateTimeStart == null
                      ? Text('시작시간을 설정하세요',
                          style: TextStyle(color: Colors.blue))
                      : Text(
                          _dateFormat.format(flightDateTimeStart!).toString(),
                          style: TextStyle(color: Colors.blue))),
              Text('~'),
              TextButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: flightDateTimeStart == null
                          ? DateTime.now()
                          : flightDateTimeStart,
                      maxTime: DateTime(2023, 12, 31, 23, 59),
                      onConfirm: (date) {
                        flightDateTimeEnd = date;
                        setState(() {});
                      },
                      locale: LocaleType.ko,
                    );
                  },
                  child: flightDateTimeEnd == null
                      ? Text('종료시간을 설정하세요',
                          style: TextStyle(color: Colors.blue))
                      : Text(_dateFormat.format(flightDateTimeEnd!).toString(),
                          style: TextStyle(color: Colors.blue))),
            ],
          ),
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
          final DateTime? flightStart = flightDateTimeStart;
          final DateTime? flightEnd = flightDateTimeEnd;
          final String purpose = controllerPurpose.text;
          final String radius = controllerDistance.text;
          final GeoPoint location = GeoPoint(
              markers.elementAt(0).position.latitude,
              markers.elementAt(0).position.longitude);
          final String accepted = 'reviewing';

          createRequest(
            uid: uid,
            army: army,
            model: model,
            flightStart: flightStart,
            flightEnd: flightEnd,
            purpose: purpose,
            radius: radius,
            location: location,
            accepted: accepted,
          );
          markers.clear();
          circles.clear();
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
    required DateTime? flightStart,
    required DateTime? flightEnd,
    required String purpose,
    required String radius,
    required GeoPoint location,
    required String accepted,
  }) async {
    final docRequest =
        FirebaseFirestore.instance.collection('flight_info').doc();

    final json = {
      'uid': uid,
      'army': army,
      'model': model,
      'flightStart': flightStart,
      'flightEnd': flightEnd,
      'purpose': purpose,
      'radius': radius,
      'location': location,
      'accepted': accepted,
    };

    await docRequest.set(json);
  }
}
