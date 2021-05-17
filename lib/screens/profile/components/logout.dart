import 'package:aloe/screens/home/home_screen.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class LogOut extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(context, 20)),
        child: Column(
          children: [
            IconButton(
              icon: (Icon(Icons.logout)),
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavScreen(
                              startingIndex: homeScreenIndex,
                              selectedWidget: HomeScreen(),
                            )));
              },
            )
          ],
        ),
      ),
    );
  }
}
