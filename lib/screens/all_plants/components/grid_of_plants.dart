import 'package:aloe/constants.dart';
import 'package:aloe/screens/all_plants/components/plant_details.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class GridOfPlants extends StatefulWidget {
  @override
  _GridOfPlantsState createState() => _GridOfPlantsState();
}

class _GridOfPlantsState extends State<GridOfPlants> {
  int plantId = 0;

  List<dynamic> allPlants = [];

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StreamBuilder(
                  stream: databaseReference.child("AllPlantes").onValue,
                  builder:
                      (BuildContext context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData) {
                      allPlants.clear();
                      List<dynamic> _values = snapshot.data.snapshot.value;

                      allPlants.addAll(_values);

                      allPlants.sort((plant1, plant2) =>
                          plant1['Nom'].compareTo(plant2['Nom']));

                      return GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          itemCount: allPlants.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                getProportionateScreenHeight(context, 300),
                            childAspectRatio: 3 / 2,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 10, bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    plantId = allPlants[index]["Id_Ma_Plante"];
                                  });

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NavScreen(
                                                startingIndex: homeScreenIndex,
                                                selectedWidget:
                                                    PlantDetailsScreen(
                                                  plantId: plantId,
                                                ),
                                              )));
                                },
                                child: Card(
                                  elevation: 4,
                                  borderOnForeground: true,
                                  color: Colors.white,
                                  child: GridTile(
                                    child: Container(
                                      height: getProportionateScreenHeight(
                                          context, 200),
                                      width: getProportionateScreenWidth(
                                          context, 600),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => Text(
                                          "Loading...",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        imageUrl: allPlants[index]["Photo"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    footer: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                          ),
                                        ),
                                        child: Text(
                                          allPlants[index]["Nom"],
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    context, 14),
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return Container();
                  }),
            ],
          )),
        ),
      ),
    );
  }
}
