import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String docID;

  const DetailPage({required this.docID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text('비행 허가 요청 부대'),
          Text('드론 기종'),
          Text('기간'),
          Text('비행목적'),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('flight_info')
                      .doc(docID)
                      .update({'accepted': true});
                },
                child: Text('승인'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('flight_info')
                      .doc(docID)
                      .update({'accepted': false});
                },
                child: Text('반려'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
