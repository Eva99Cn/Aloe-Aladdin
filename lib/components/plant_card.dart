import 'package:aloe/screens/all_plants/components/plant_details.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class PlantCard extends StatefulWidget {
  final List allPlants;
  final int index;
  const PlantCard({
    Key key,
    @required this.allPlants,
    @required this.index,
  }) : super(key: key);

  @override
  _PlantCardState createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NavScreen(
                        startingIndex: homeScreenIndex,
                        selectedWidget: PlantDetailsScreen(
                          plantId: widget.allPlants[widget.index]
                              ["Id_Ma_Plante"],
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
                imageUrl: widget.allPlants[widget.index]["Photo"],
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
                  widget.allPlants[widget.index]["Nom"],
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(context, 14),
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
  }
}
