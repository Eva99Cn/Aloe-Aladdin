import 'dart:collection';

import 'package:aloe/components/add_watering_button.dart';
import 'package:aloe/models/UserPlant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aloe/constants.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var formatter = new DateFormat('yyyy-MM-dd hh:mm');
  var currentUser = FirebaseAuth.instance.currentUser;
  LinkedHashMap<dynamic, dynamic> myPlants = new LinkedHashMap();
  LinkedHashMap<dynamic, dynamic> myPlant = new LinkedHashMap();

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
                  "Mes plantes",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(context, 15),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder(
                    stream: databaseReference
                        .child("Users")
                        .child(currentUser.uid)
                        .onValue,
                    builder:
                        (BuildContext context, AsyncSnapshot<Event> snapshot) {
                      if (snapshot.hasData) {
                        List<Widget> widgets = [];

                        myPlants.clear();
                        myPlants = snapshot.data.snapshot.value;

                        myPlants.forEach((key, value) {
                          // TODO get photo of the plant

                          widgets.add(AddWateringButton(
                            plantName: value.name,
                            isForActivitiesScreen: false,
                          ));
                        });
                        return Column(children: widgets);
                      }
                    })

                // /*

                // Exemple d'utilisation : à corriger et à implémenter
                // */
                // AddWateringButton(
                //   plantName: "capu",
                //   isForActivitiesScreen: false,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
