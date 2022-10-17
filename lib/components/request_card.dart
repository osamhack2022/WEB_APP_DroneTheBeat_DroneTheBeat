import 'package:flutter/material.dart';
import 'package:helloworld/components/accept_icon.dart';
import 'package:helloworld/pages/detail_page.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatelessWidget {
  final String model;
  final DateTime duration;
  final String index;
  final String accepted;
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
    DateFormat _dateFormat = DateFormat('y-MM-d H:mm');
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
          subtitle: Text(_dateFormat.format(duration)),
          trailing: AcceptIcon(accepted: accepted),
        ),
      ),
    );
  }
}
