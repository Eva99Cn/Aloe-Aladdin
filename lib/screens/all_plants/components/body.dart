import 'package:aloe/components/return_button.dart';
import 'package:aloe/constants.dart';
import 'package:aloe/screens/all_plants/components/grid_of_plants.dart';
import 'package:aloe/screens/all_plants/components/plant_search.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
