import 'package:flutter/material.dart';
import 'package:helloworld/components/custom_text_field.dart';

class FlightAreaInfo extends StatelessWidget {
  final controllerDistance = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          prefixText: '비행 반경(km)',
          hintText: '숫자만 입력',
          controller: controllerDistance,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("비행반경 저장"),
        ),
      ],
    );
  }
}
