import 'package:aloe/components/add_watering_button.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                                            widgetIndex: 1,
                                          )));
                            },
                            child: Text("Ajouter des plantes"))
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
                                    plantId = userPlants[index]["Id_Ma_Plante"];
                                    //TODO : Aller au détail de la plante
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
                                    "Prochain arrosage ",
                                    style: TextStyle(
                                      fontSize: getProportionateScreenHeight(
                                          context, 14),
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    userPlants[index]["prochainArrosage"] !=
                                            null
                                        ? "D-" +
                                            formatter
                                                .parse(userPlants[index]
                                                    ["prochainArrosage"])
                                                .difference(formatter.parse(
                                                    userPlants[index]
                                                        ["arrosageDate"]))
                                                .inDays
                                                .toString()
                                        : "Pas défini",
                                    style: TextStyle(
                                      fontSize: getProportionateScreenHeight(
                                          context, 14),
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                height:
                                    getProportionateScreenHeight(context, 70),
                                width: getProportionateScreenWidth(context, 40),
                                child: AddWateringButton(
                                  plantName: userPlants[index]["NomPlante"],
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
