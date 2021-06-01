import 'dart:collection';

import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/screens/my_plants/components/my_plant_details.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class MyPlantsList extends StatefulWidget {
  final int plantId;
  const MyPlantsList({Key key, this.plantId}) : super(key: key);
  @override
  _MyPlantsListState createState() => _MyPlantsListState();
}

class _MyPlantsListState extends State<MyPlantsList> {
  int plantId = 0;

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
                    userPlants.add(value);
                  });
                  databaseReference
                      .child("AllPlantes")
                      .once()
                      .then((DataSnapshot snapshotPlant) {
                    List<dynamic> _values = snapshotPlant.value;
                    allPlants.addAll(_values);
                  });
                } catch (err) {
                  return Center(
                    child: Column(
                      children: [
                        Text("Pas de plantes ajoutées"),
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
                      return Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: Column(
                          children: [
                            ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    plantId = userPlants[index]["IdPlante"];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NavScreen(
                                                  startingIndex:
                                                      homeScreenIndex,
                                                  selectedWidget:
                                                      MyPlantDetailsScreen(
                                                    plantId: userPlants[index]
                                                        ["IdPlante"],
                                                  ),
                                                )));
                                  });
                                },
                                child: Container(
                                  height:
                                      getProportionateScreenHeight(context, 70),
                                  width:
                                      getProportionateScreenWidth(context, 40),
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
                                  fontSize:
                                      getProportionateScreenHeight(context, 14),
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Voir plus de détails ",
                                    style: TextStyle(
                                      fontSize: getProportionateScreenHeight(
                                          context, 14),
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
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
