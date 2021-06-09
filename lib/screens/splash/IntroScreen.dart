import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../../constants.dart';
import '../../size_config.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 2,
      navigateAfterSeconds: NavScreen(
        startingIndex: homeScreenIndex,
      ),
      title: Text(
        'Aloe',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getProportionateScreenWidth(context, 40),
            color: Colors.black),
      ),
      backgroundColor: Colors.white,
      loaderColor: primaryColor,
      image: Image(
        image: AssetImage('assets/images/logo.png'),
      ),
      photoSize: getProportionateScreenHeight(context, 100),
    );
  }
}
