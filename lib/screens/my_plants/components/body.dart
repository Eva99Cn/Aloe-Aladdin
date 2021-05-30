import 'dart:collection';

import 'package:aloe/components/add_watering_button.dart';
import 'package:aloe/components/returnButton.dart';
import 'package:aloe/models/UserPlant.dart';
import 'package:aloe/screens/my_plants/components/plants_details.dart';
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
    UserPlant userPlant;
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "ICI page Mes plantes",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(context, 15),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /*
                
                Exemple d'utilisation : à corriger et à implémenter
                */
                AddWateringButton(
                  plantName: "capu",
                  isForActivitiesScreen: false,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
