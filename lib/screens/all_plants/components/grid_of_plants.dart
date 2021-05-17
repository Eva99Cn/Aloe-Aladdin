import 'package:aloe/components/plant_card.dart';
import 'package:aloe/constants.dart';
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
                            return PlantCard(
                              allPlants: allPlants,
                              index: index,
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
