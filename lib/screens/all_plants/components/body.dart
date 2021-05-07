import 'package:aloe/constants.dart';
import 'package:aloe/screens/all_plants/components/plant_details.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  int selectedOption = 0;
  int plantId = 0;

  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      buildGridOfPlants(),
      PlantDetailsScreen(
        plantId: plantId,
      ),
    ];

    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (selectedOption == 0) {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: NavScreen(
                                  startingIndex: homeScreenIndex,
                                )));
                      } else {
                        setState(() {
                          selectedOption = 0;
                        });
                      }
                    }),
                AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    reverseDuration: Duration(milliseconds: 800),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) =>
                            ScaleTransition(child: child, scale: animation),
                    child: widgetOptions.elementAt(selectedOption)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridOfPlants() {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('AllPlantes');
    List<dynamic> allPlants = [];
    return Column(
      children: [
        StreamBuilder(
            stream: databaseReference.onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                allPlants.clear();
                List<dynamic> _values = snapshot.data.snapshot.value;

                allPlants.addAll(_values);

                allPlants.sort(
                    (plant1, plant2) => plant1['Nom'].compareTo(plant2['Nom']));

                return GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: allPlants.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          getProportionateScreenHeight(context, 300),
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing:
                          getProportionateScreenHeight(context, 0),
                      mainAxisSpacing: getProportionateScreenWidth(context, 10),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 10, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              plantId = allPlants[index]["Id_Ma_Plante"];
                              selectedOption = 1;
                            });
                          },
                          child: Column(
                            children: [
                              Flexible(
                                child: Card(
                                  elevation: 0,
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
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text(
                                      allPlants[index]["Nom"],
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
                        ),
                      );
                    });
              }
              return Container();
            }),
      ],
    );
  }
}
