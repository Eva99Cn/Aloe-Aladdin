import 'dart:collection';

import 'package:aloe/components/add_watering_button.dart';
import 'package:aloe/components/return_button.dart';
import 'package:aloe/models/UserPlant.dart';
import 'package:aloe/screens/all_plants/all_plants_screen.dart';
import 'package:aloe/screens/all_plants/components/grid_of_plants.dart';
import 'package:aloe/screens/home/home_screen.dart';
import 'package:aloe/screens/my_plants/components/my_plants_list.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aloe/constants.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';

import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReturnButton(press: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: NavScreen(
                              startingIndex: homeScreenIndex,
                            )));
                  }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: kPrimaryColor,
                          padding: const EdgeInsets.all(8.0)),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavScreen(
                                      startingIndex: homeScreenIndex,
                                      selectedWidget: AllPlantsScreen(),
                                    )));
                      },
                      child: Text("Ajouter des plantes")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Mes plantes"),
                  ),
                  MyPlantsList()
                ],
              ),
            )),
      ),
    );
  }
}
