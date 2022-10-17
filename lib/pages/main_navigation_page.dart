import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/pages/admin_home_page.dart';
import 'package:helloworld/pages/all_flight_areas_map.dart';
import 'package:helloworld/pages/flight_request_page.dart';
import 'package:helloworld/pages/my_info_page.dart';

class MainNavigationPage extends StatefulWidget {
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static List<Widget> _adminPages = <Widget>[
    AdminHomePage(),
    AllFlightAreasMap(),
    MyInfoPage(),
  ];

  static List<Widget> _userPages = <Widget>[
    AdminHomePage(),
    FlightRequestPage(),
    MyInfoPage(),
  ];

  bool isAdmin() {
    if (FirebaseAuth.instance.currentUser!.uid ==
        'jHBGhQtOR7YmWX3Zy1Bk08Yqp4y2') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isAdmin()
            ? _adminPages.elementAt(_selectedIndex)
            : _userPages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: '비행 목록',
          ),
          isAdmin()
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.airplanemode_active),
                  label: '전체 비행',
                )
              : BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: '비행 신청',
                ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: '내 정보',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
