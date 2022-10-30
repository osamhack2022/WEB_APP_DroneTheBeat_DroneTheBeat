import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String email;
  final String name;
  final String birthday;
  final String phoneNumber;

  const UserInfoCard({
    required this.email,
    required this.name,
    required this.birthday,
    required this.phoneNumber,
  });

  bool isAdmin() {
    if (FirebaseAuth.instance.currentUser!.uid ==
        'jHBGhQtOR7YmWX3Zy1Bk08Yqp4y2') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.account_box, size: 100),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAdmin() ? 'Admin' : 'User',
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ],
          ),
          _buildInfo(email, Icons.email),
          _buildInfo(
              birthday.substring(0, 4) +
                  '-' +
                  birthday.substring(4, 6) +
                  '-' +
                  birthday.substring(6),
              Icons.cake),
          _buildInfo(phoneNumber, Icons.phone),
        ],
      ),
    );
  }

  Widget _buildInfo(String info, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(
          info,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Source Sans Pro',
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
