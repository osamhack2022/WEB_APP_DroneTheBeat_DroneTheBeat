import 'package:flutter/material.dart';
import 'package:helloworld/components/custom_text_field.dart';
import 'package:helloworld/styles.dart';

class FlightRequestPage extends StatelessWidget {
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
          CustomTextField(prefixText: "비행 허가 요청 부대", hintText: ""),
          CustomTextField(prefixText: "드론 기종", hintText: ""),
          CustomTextField(prefixText: "기간", hintText: ""),
          CustomTextField(prefixText: "비행 목적", hintText: ""),
          CustomTextField(prefixText: "비행 반경", hintText: ""),
        ],
      ),
    );
  }
}
