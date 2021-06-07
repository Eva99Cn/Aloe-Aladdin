import 'dart:async';

import 'package:aloe/components/plant_card.dart';
import 'package:aloe/components/return_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
            physics: ScrollPhysics(),
            itemCount: allPlants.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: getProportionateScreenHeight(context, 300),
              childAspectRatio: 3 / 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return PlantCard(
                  plantId: allPlants[index]["Id_Ma_Plante"],
                  plantName: allPlants[index]["Nom"],
                  pictureUrl: allPlants[index]["Photo"]);
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
        String plantSpecies =
            searchedPlants[i]['Espèce'].toString().toUpperCase();
        String plantDifficulty = searchedPlants[i]['Difficulté_Entretien']
            .toString()
            .toUpperCase(); // Simple,Moyen,Difficile

        if (plantName.contains(query.toUpperCase()) ||
            plantDifficulty.contains(query.toUpperCase()) ||
            plantSpecies.contains(query.toUpperCase())) {
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
