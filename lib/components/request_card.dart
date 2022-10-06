import 'package:flutter/material.dart';
import 'package:helloworld/pages/detail_page.dart';

class RequestCard extends StatelessWidget {
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
            child: Text("111"),
          ),
          title: Text("111"),
          subtitle: Text("111"),
          trailing: const Icon(Icons.check),
        ),
      ),
    );
  }
}
