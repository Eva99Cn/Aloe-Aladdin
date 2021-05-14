import 'dart:async';

import 'package:aloe/components/returnButton.dart';
import 'package:aloe/screens/all_plants/components/plant_details.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PlantSearch extends StatefulWidget {
  final String query;
  const PlantSearch({Key key, this.query}) : super(key: key);
  @override
  _PlantSearchState createState() => _PlantSearchState();
}

class _PlantSearchState extends State<PlantSearch> {
  List<dynamic> allPlants = [];
  int plantId;
  bool hasNotFoundPlants = false;
  @override
  void initState() {
    searchMethod("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReturnButton(),
        TextField(
          decoration:
              InputDecoration(icon: Icon(Icons.search), hintText: "Rechercher"),
          onChanged: (text) {
            searchMethod(text);
          },
        ),
        Visibility(
          visible: hasNotFoundPlants,
          child: Text("Aucun résultat"),
        ),
        GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: allPlants.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: getProportionateScreenHeight(context, 300),
              childAspectRatio: 3 / 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5, right: 10, bottom: 10),
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
                                  selectedWidget: PlantDetailsScreen(
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
                        height: getProportionateScreenHeight(context, 200),
                        width: getProportionateScreenWidth(context, 600),
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
                                  getProportionateScreenHeight(context, 14),
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
            }),
      ],
    );
  }

  void searchMethod(String query) {
    DatabaseReference searchReference =
        FirebaseDatabase.instance.reference().child("AllPlantes");
    searchReference.once().then((DataSnapshot snapshot) {
      List<dynamic> searchedPlants = snapshot.value;
      allPlants.clear();
      for (int i = 0; i < searchedPlants.length; i++) {
        String plantName = searchedPlants[i]['Nom'].toString().toUpperCase();

        if (plantName.contains(query.toUpperCase())) {
          allPlants.add(searchedPlants[i]);
        }
      }
      if (allPlants.isEmpty) {
        setState(() {
          hasNotFoundPlants = true;
        });
      } else {
        setState(() {
          hasNotFoundPlants = false;
        });
      }
      Timer(Duration(seconds: 1), () {
        setState(() {
          //
        });
      });
    });
  }
}
