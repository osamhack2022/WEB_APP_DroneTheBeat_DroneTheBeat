import 'package:flutter/material.dart';

class AcceptIcon extends StatelessWidget {
  final String accepted;

  const AcceptIcon({required this.accepted});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    Color textColor;
    if (accepted == 'reviewing') {
      text = '검토중';
      color = Color(0xffe5dd93);
      textColor = Color(0xffa19740);
    } else if (accepted == 'accepted') {
      text = '승인';
      color = Color(0xffB5F5D1);
      textColor = Color(0xff19973c);
    } else {
      text = '반려';
      color = Color(0xfff1bfbf);
      textColor = Color(0xffc84f4f);
    }
    return Container(
      width: 50,
      height: 25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
