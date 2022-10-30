import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/components/user_info_card.dart';

class MyInfoPage extends StatelessWidget {
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
                    '내 정보',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text('로그아웃'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .where('email', whereIn: [
                FirebaseAuth.instance.currentUser!.email
              ]).snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return UserInfoCard(
                  email: snapshot.data.docs[0]['email'],
                  name: snapshot.data.docs[0]['name'],
                  birthday: snapshot.data.docs[0]['birthday'],
                  phoneNumber: snapshot.data.docs[0]['phoneNumber'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
