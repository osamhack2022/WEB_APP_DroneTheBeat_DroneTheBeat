import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helloworld/pages/login_page.dart';
import 'package:helloworld/pages/user_home_page.dart';
import 'firebase_options.dart';
import 'pages/admin_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser!.uid ==
                'jHBGhQtOR7YmWX3Zy1Bk08Yqp4y2') {
              return AdminHomePage();
            } else {
              return UserHomePage();
            }
          } else {
            return LoginPage();
          }
        }),
      ),
    );
  }
}
