import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/pages/flight_request_page.dart';
import 'package:helloworld/read_data/get_request_info.dart';
import '../components/request_card.dart';

class HomePage extends StatelessWidget {
  List<String> docIDs = [];

  Future getDocRequest() async {
    await FirebaseFirestore.instance.collection('flight_info').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: FutureBuilder(
        future: getDocRequest(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: docIDs.length,
            itemBuilder: (context, index) {
              return GetRequestInfo(
                  index: (index + 1).toString(), documentId: docIDs[index]);
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Main Page"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FlightRequestPage()),
            );
          },
          icon: Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
