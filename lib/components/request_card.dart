import 'package:flutter/material.dart';
import 'package:helloworld/components/accept_icon.dart';
import 'package:helloworld/pages/detail_page.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatelessWidget {
  final String model;
  final String purpose;
  final DateTime flightStart;
  final DateTime flightEnd;
  final String index;
  final String accepted;
  final String docID;
  final String uid;

  const RequestCard({
    required this.model,
    required this.purpose,
    required this.flightStart,
    required this.flightEnd,
    required this.index,
    required this.accepted,
    required this.docID,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat _dateFormat = DateFormat('MM/d  HH:mm');

    bool isSameDate() {
      if (flightStart.year != flightEnd.year ||
          flightStart.month != flightEnd.month ||
          flightStart.day != flightEnd.day) {
        return false;
      }
      return true;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
      child: InkWell(
        hoverColor: Colors.white,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(docID: docID, uid: uid)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      isSameDate()
                          ? '${_dateFormat.format(flightStart)} ~ ${DateFormat('HH:mm').format(flightEnd)}'
                          : '${_dateFormat.format(flightStart)} ~ ${_dateFormat.format(flightEnd)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      purpose,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AcceptIcon(accepted: accepted),
                  SizedBox(height: 10),
                  Container(
                    width: 35,
                    height: 35,
                    child: Center(child: Icon(Icons.keyboard_arrow_right)),
                    decoration: BoxDecoration(
                        color: Color(0xffF3F4F5),
                        borderRadius: BorderRadius.circular(10)),
                  )
                ],
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
