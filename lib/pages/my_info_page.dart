import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Text('로그아웃'),
        ),
      ],
    ));
  }
}
