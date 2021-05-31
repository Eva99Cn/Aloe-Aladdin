import 'package:aloe/screens/splash/IntroScreen.dart';
import 'package:aloe/services/notifications_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
            MyApp(),
          ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aloe',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        accentColor: Colors.black,
        fontFamily: 'Montserrat',
      ),
      home: IntroScreen(),
    );
  }
}
