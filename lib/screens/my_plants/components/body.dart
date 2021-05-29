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
  var formatter = new DateFormat('yyyy-MM-dd hh:mm');
  var currentUser = FirebaseAuth.instance.currentUser;
  LinkedHashMap<dynamic, dynamic> myPlants = new LinkedHashMap();

  @override
  Widget build(BuildContext context) {
    UserPlant userPlant;
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Mes plantes"),
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

                        try {
                          myPlants.forEach((key, value) {
                            widgets.add(PlantDetailsItem(
                              plantInformation: value,
                            ));
                          });
                        } catch (err) {
                          return Center(
                            child: Column(
                              children: [
                                Text("Pas de plantes ajoutées"),
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
                                                    startingIndex:
                                                        homeScreenIndex,
                                                    widgetIndex: 1,
                                                  )));
                                    },
                                    child: Text("Ajouter des plantes"))
                              ],
                            ),
                          );
                        } //catch

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: widgets);
                      }
                      return Container();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
