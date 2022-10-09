import 'package:flutter/material.dart';
import 'package:helloworld/pages/detail_page.dart';

class RequestCard extends StatelessWidget {
  final String model;
  final String duration;
  final String index;

  const RequestCard({required this.model, required this.duration, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage()),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            child: Text(index),
          ),
          title: Text(model),
          subtitle: Text(duration),
          trailing: const Icon(Icons.check),
        ),
      ),
    );
  }
}
