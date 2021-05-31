import 'dart:ui';

import 'package:aloe/components/add_watering_button.dart';
import 'package:aloe/components/default_button.dart';
import 'package:aloe/screens/all_plants/all_plants_screen.dart';
import 'package:aloe/screens/all_plants/components/grid_of_plants.dart';
import 'package:aloe/screens/my_plants/my_plants_screen.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ActivitiesList extends StatefulWidget {
  @override
  _ActivitiesListState createState() => _ActivitiesListState();
}

class _ActivitiesListState extends State<ActivitiesList> {
  int plantId = 0;
  DateTime nowDate = DateTime.now();

  List<dynamic> userPlants = [];
  List<dynamic> allPlants = [];

  @override
  void initState() {
    super.initState();
    databaseReference
        .child("AllPlantes")
        .once()
        .then((DataSnapshot snapshotPlant) {
      List<dynamic> _values = snapshotPlant.value;
      allPlants.addAll(_values);
    });
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StreamBuilder(
            stream:
                databaseReference.child("Users").child(currentUser.uid).onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                userPlants.clear();
                try {
                  Map<dynamic, dynamic> _values = snapshot.data.snapshot.value;
                  _values.forEach((key, value) {
                    if (value["arrosageDate"] != null) {
                      userPlants.add(value);
                    }
                  });
                } catch (err) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          "Pas de plantes ajoutées",
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(
                                  context, bodyFontSize)),
                        ),
                        DefaultButton(
                            press: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavScreen(
                                            startingIndex: homeScreenIndex,
                                            selectedWidget: AllPlantsScreen(),
                                          )));
                            },
                            text: "Ajouter des plantes")
                      ],
                    ),
                  );
                }

                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: userPlants.length,
                    itemBuilder: (BuildContext context, int index) {
                      var isNextWateringDefined =
                          userPlants[index]["prochainArrosage"] != null;
                      var hasWateringDatePassed = formatter
                              .parse(userPlants[index]["prochainArrosage"])
                              .difference(nowDate)
                              .inDays <
                          0;
                      int daysRemainingBeforeWatering = formatter
                          .parse(userPlants[index]["prochainArrosage"])
                          .difference(nowDate)
                          .inDays
                          .abs();
                      return userPlants.length > 0
                          ? Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Ajouter un arrosage à vos plantes",
                                    style: TextStyle(
                                        fontSize: getProportionateScreenWidth(
                                            context, bodyFontSize)),
                                  ),
                                  DefaultButton(
                                      press: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NavScreen(
                                                      startingIndex:
                                                          homeScreenIndex,
                                                      selectedWidget:
                                                          MyPlantsScreen(),
                                                    )));
                                      },
                                      text: "Ajouter des plantes")
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: GestureDetector(
                                      onTap: () {
                                        if (!mounted) return;
                                        setState(() {
                                          plantId =
                                              userPlants[index]["Id_Ma_Plante"];
                                          //TODO : Aller au détail de la plante
                                        });
                                      },
                                      child: Container(
                                        height: getProportionateScreenHeight(
                                            context, 70),
                                        width: getProportionateScreenWidth(
                                            context, 40),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) => Text(
                                            "Loading...",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          imageUrl: plantUrlFinder(index),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      userPlants[index]["NomPlante"],
                                      style: TextStyle(
                                        fontSize: getProportionateScreenHeight(
                                            context, 14),
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Arrosage ",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    context, 14),
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          isNextWateringDefined
                                              ? hasWateringDatePassed
                                                  ? "D + " +
                                                      daysRemainingBeforeWatering
                                                          .toString()
                                                  : "D - " +
                                                      daysRemainingBeforeWatering
                                                          .toString()
                                              : "Pas défini",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    context, 14),
                                            color: Colors.black,
                                          ),
                                        ),
                                        LinearProgressIndicator(
                                          semanticsValue: formatter
                                              .parse(userPlants[index]
                                                  ["prochainArrosage"])
                                              .difference(nowDate)
                                              .inDays
                                              .toString(),
                                          backgroundColor: Colors.grey,
                                          valueColor: AlwaysStoppedAnimation<
                                              Color>(formatter
                                                      .parse(userPlants[index]
                                                          ["prochainArrosage"])
                                                      .difference(nowDate)
                                                      .inDays >
                                                  0
                                              ? kPrimaryColor
                                              : Colors.red),
                                          value: 1 -
                                              (formatter
                                                      .parse(userPlants[index]
                                                          ["prochainArrosage"])
                                                      .difference(nowDate)
                                                      .inSeconds
                                                      .toDouble() /
                                                  formatter
                                                      .parse(userPlants[index]
                                                          ["prochainArrosage"])
                                                      .difference(formatter
                                                          .parse(userPlants[
                                                                  index]
                                                              ["arrosageDate"]))
                                                      .inSeconds
                                                      .toDouble()),
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      height: getProportionateScreenHeight(
                                          context, 60),
                                      width: getProportionateScreenWidth(
                                          context, 20),
                                      child: AddWateringButton(
                                        plantName: userPlants[index]
                                            ["NomPlante"],
                                        isForActivitiesScreen: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    });
              }
              return Container();
            }),
      ],
    );
  }

  String plantUrlFinder(int index) {
    String url = "";
    allPlants.forEach((element) {
      if (element["Id_Ma_Plante"] == userPlants[index]["IdPlante"]) {
        url = element["Photo"].toString();
      }
    });
    return url;
  }
}
