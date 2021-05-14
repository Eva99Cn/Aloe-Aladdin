import 'package:aloe/components/returnButton.dart';
import 'package:aloe/constants.dart';
import 'package:aloe/screens/all_plants/components/grid_of_plants.dart';
import 'package:aloe/screens/all_plants/components/plant_details.dart';
import 'package:aloe/screens/all_plants/components/plant_search.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class Body extends StatefulWidget {
  final Widget selectedWiget;
  const Body({Key key, this.selectedWiget}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedOption = 0;
  int plantId = 0;
  String query;
  Widget selectedWidget;
  List<dynamic> allPlants = [];

  @override
  void initState() {
    super.initState();
    selectedWidget =
        widget.selectedWiget != null ? widget.selectedWiget : GridOfPlants();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      buildGridOfPlants(),
      PlantDetailsScreen(
        plantId: plantId,
      ),
      PlantSearch(
        query: query,
      )
    ];

    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ReturnButton(),
                    Spacer(),
                    Visibility(
                      visible: selectedOption == 0 ? true : false,
                      child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavScreen(
                                          startingIndex: homeScreenIndex,
                                          selectedWidget: PlantSearch(),
                                        )));
                          }),
                    ),
                  ],
                ),
                selectedWidget,
                /*  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    reverseDuration: Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) =>
                            ScaleTransition(child: child, scale: animation),
                    child: widgetOptions.elementAt(selectedOption)),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridOfPlants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StreamBuilder(
            stream: databaseReference.child("AllPlantes").onValue,
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
                            Navigator.pushReplacement(
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
                                height:
                                    getProportionateScreenHeight(context, 200),
                                width:
                                    getProportionateScreenWidth(context, 600),
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
                                      fontSize: getProportionateScreenHeight(
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
    );
  }
}
