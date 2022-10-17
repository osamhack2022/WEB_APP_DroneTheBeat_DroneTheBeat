import 'package:flutter/material.dart';

class AcceptIcon extends StatelessWidget {
  final String accepted;

  const AcceptIcon({required this.accepted});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    if (accepted == 'reviewing') {
      text = '검토중';
      color = Colors.grey;
    } else if (accepted == 'accepted') {
      text = '승인';
      color = Colors.lightGreen;
    } else {
      text = '반려';
      color = Color(0xfff46c36);
    }
    return Container(
        width: 50,
        height: 25,
        child: Column(
          children: [
            Text(text),
          ],
        ),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black12, width: 3)));
  }
}
