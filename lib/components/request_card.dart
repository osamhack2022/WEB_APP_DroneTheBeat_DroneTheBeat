import 'package:flutter/material.dart';
import 'package:helloworld/pages/detail_page.dart';

class RequestCard extends StatelessWidget {
  final String model;
  final String duration;
  final String index;
  final bool accepted;
  final String docID;

  const RequestCard({
    required this.model,
    required this.duration,
    required this.index,
    required this.accepted,
    required this.docID,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(docID: docID)),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            child: Text(index),
          ),
          title: Text(model),
          subtitle: Text(duration),
          trailing:
              accepted ? const Icon(Icons.check) : const Icon(Icons.close),
        ),
      ),
    );
  }
}
