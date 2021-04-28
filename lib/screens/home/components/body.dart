import 'package:aloe/components/dashbord_button.dart';
import 'package:aloe/constants.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  int selectedIndex = 0;

  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      buildDashboard(context),
      HomeScreen(), // TODO : Toutes les plantes
      currentUser != null
          ? (currentUser.emailVerified
              ? HomeScreen()
              : NavScreen(
                  startingIndex: signInScreenIndex,
                ))
          : NavScreen(
              startingIndex: signInScreenIndex,
            ), //TODO : Mes plantes
      currentUser != null
          ? (currentUser.emailVerified
              ? HomeScreen()
              : NavScreen(
                  startingIndex: signInScreenIndex,
                ))
          : NavScreen(
              startingIndex: signInScreenIndex,
            ), // TODO : Activités
    ];

    return SingleChildScrollView(
        child: SafeArea(
            child: Column(
      children: [
        widgetOptions.elementAt(selectedIndex),
      ],
    )));
  }

  Widget buildDashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        DashboardButton(
          text: "Toutes les plantes",
          press: () {
            currentUser == null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (NavScreen(
                              startingIndex: signInScreenIndex,
                            ))))
                : setState(() {
                    selectedIndex = 1;
                  });
          },
        ),
        DashboardButton(
          text: "Mes Plantes",
          press: () {
            currentUser == null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (NavScreen(
                              startingIndex: signInScreenIndex,
                            ))))
                : setState(() {
                    selectedIndex = 1;
                  });
          },
        ),
        DashboardButton(
          text: "Activités",
          press: () {
            currentUser == null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (NavScreen(
                              startingIndex: signInScreenIndex,
                            ))))
                : setState(() {
                    selectedIndex = 1;
                  });
          },
        )
      ]),
    );
  }
}
