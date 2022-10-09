import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/request_card.dart';

class GetRequestInfo extends StatelessWidget {
  final String documentId;
  final String index;

  const GetRequestInfo({required this.documentId, required this.index});

  @override
  Widget build(BuildContext context) {
    CollectionReference requests =
        FirebaseFirestore.instance.collection('flight_info');

    return FutureBuilder<DocumentSnapshot>(
      future: requests.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return RequestCard(
              index: index, model: data['model'], duration: data['duration']);
        }
        return Text('loading..');
      }),
    );
  }
}
