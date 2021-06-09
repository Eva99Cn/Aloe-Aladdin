import 'package:aloe/components/default_button.dart';
import 'package:aloe/screens/all_plants/all_plants_screen.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aloe/constants.dart';
import 'package:aloe/models/UserPlant.dart';
import 'package:aloe/services/notifications_services.dart';

import '../size_config.dart';

class AddPlantsButton extends StatefulWidget {
  @override
  _AddPlantsButtonState createState() => _AddPlantsButtonState();
}

class _AddPlantsButtonState extends State<AddPlantsButton> {
  DateTime initialDate = DateTime.now();
  DateTime choosenDateTime = DateTime.now();
  Map<dynamic, dynamic> plantInformation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
          child: DefaultButton(
              press: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavScreen(
                              startingIndex: homeScreenIndex,
                              selectedWidget: AllPlantsScreen(),
                            )));
              },
              text: "Ajouter des plantes")),
    );
  }
}
