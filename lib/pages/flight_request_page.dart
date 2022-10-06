import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/components/custom_text_field.dart';
import 'package:helloworld/styles.dart';

class FlightRequestPage extends StatelessWidget {
  final controllerArmy = TextEditingController();
  final controllerModel = TextEditingController();
  final controllerDuration = TextEditingController();
  final controllerPurpose = TextEditingController();
  final controllerFlightArea = TextEditingController();

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
              controller: controllerArmy),
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
          CustomTextField(
            prefixText: "비행 반경",
            hintText: "",
            controller: controllerFlightArea,
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
          final army = controllerArmy.text;
          final model = controllerModel.text;
          final duration = controllerDuration.text;
          final purpose = controllerPurpose.text;
          final flightArea = controllerFlightArea.text;

          createRequest(
              army: army,
              model: model,
              duration: duration,
              purpose: purpose,
              flightArea: flightArea);
        },
        child: Text("신청"),
      ),
    );
  }

  Future createRequest(
      {required String army,
      required String model,
      required String duration,
      required String purpose,
      required String flightArea}) async {
    final docRequest =
        FirebaseFirestore.instance.collection('flight_info').doc();

    final json = {
      'army': army,
      'model': model,
      'duration': duration,
      'purpose': purpose,
      'flightArea': flightArea,
    };

    await docRequest.set(json);
  }
}
