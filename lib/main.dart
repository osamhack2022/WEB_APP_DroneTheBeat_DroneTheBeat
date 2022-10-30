import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helloworld/pages/login_page.dart';
import 'package:helloworld/pages/main_navigation_page.dart';
import 'package:helloworld/pages/user_home_page.dart';
import 'package:helloworld/utils.dart';
import 'firebase_options.dart';
import 'pages/admin_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xffF3F4F5)),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return MainNavigationPage();
          } else {
            return LoginPage();
          }
        }),
      ),
    );
  }
}
