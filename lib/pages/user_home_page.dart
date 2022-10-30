import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/pages/flight_request_page.dart';
import '../components/request_card.dart';

class UserHomePage extends StatefulWidget {
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int selectedId = 0;

  List<Stream> streams = [
    FirebaseFirestore.instance
        .collection('flight_info')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('flightStart', descending: false)
        .snapshots(),
    FirebaseFirestore.instance
        .collection('flight_info')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('accepted', isEqualTo: 'reviewing')
        .orderBy('flightStart', descending: false)
        .snapshots(),
    FirebaseFirestore.instance
        .collection('flight_info')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('accepted', whereIn: ['accepted', 'declined'])
        .orderBy('flightStart', descending: false)
        .snapshots(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '비행 신청 목록',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FlightRequestPage()),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.create, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            '신청 작성',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildHeaderSelectButton(0, '전체')),
                    SizedBox(width: 2),
                    Expanded(child: _buildHeaderSelectButton(1, '검토중')),
                    SizedBox(width: 2),
                    Expanded(child: _buildHeaderSelectButton(2, '검토완료')),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: streams[selectedId],
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return RequestCard(
                        model: snapshot.data.docs[index]['model'],
                        purpose: snapshot.data.docs[index]['purpose'],
                        flightStart:
                            snapshot.data.docs[index]['flightStart'].toDate(),
                        flightEnd:
                            snapshot.data.docs[index]['flightEnd'].toDate(),
                        index: (index + 1).toString(),
                        accepted: snapshot.data.docs[index]['accepted'],
                        docID: snapshot.data.docs[index].id,
                        uid: snapshot.data.docs[index]['uid'],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _buildHeaderSelectButton(int id, String text) {
    return Container(
      width: 70,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: id == selectedId
            ? [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: Colors.black26,
                )
              ]
            : [],
      ),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            id == 2
                ? Icon(
                    Icons.circle,
                    size: 10,
                    color: Color(0xfff1bfbf),
                  )
                : Container(),
            id == 0
                ? Container()
                : Icon(
                    Icons.circle,
                    size: 10,
                    color: id == 1 ? Color(0xffe5dd93) : Color(0xffB5F5D1),
                  ),
            SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: id == selectedId ? Colors.black : Color(0xff797979),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            selectedId = id;
          });
        },
      ),
    );
  }
}
