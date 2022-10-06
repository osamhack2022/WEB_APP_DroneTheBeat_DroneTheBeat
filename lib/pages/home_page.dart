import 'package:flutter/material.dart';
import 'package:helloworld/pages/flight_request_page.dart';
import '../components/request_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        children: [
          RequestCard(),
          RequestCard(),
        ],
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
