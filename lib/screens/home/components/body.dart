import 'package:aloe/components/dashbord_button.dart';
import 'package:aloe/constants.dart';
import 'package:aloe/screens/activities/activities_screen.dart';
import 'package:aloe/screens/all_plants/all_plants_screen.dart';
import 'package:aloe/screens/my_plants/my_plants_screen.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final int widgetIndex;
  const Body({Key key, this.widgetIndex}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedOption = 0;
  @override
  void initState() {
    super.initState();
    selectedOption = widget.widgetIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      buildDashboard(context),
      AllPlantsScreen(), // TODO : Toutes les plantes
      MyPlantsScreen(), // TODO : Mes plantes
      MyActivitiesScreen(), // TODO : Activités
    ];

    return SingleChildScrollView(
        child: SafeArea(
            child: Column(
      children: [
        widgetOptions.elementAt(selectedOption),
      ],
    )));
  }

  Widget buildDashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        DashboardButton(
          text: "Toutes les plantes",
          press: () {
            setState(() {
              selectedOption = 1;
            });
          },
        ),
        DashboardButton(
          text: "Mes Plantes",
          press: () {
            currentUser == null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (NavScreen(
                              startingIndex: 2,
                            ))))
                : setState(() {
                    selectedOption = 2;
                  });
          },
        ),
        DashboardButton(
          text: "Activités",
          press: () {
            currentUser == null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (NavScreen(
                              startingIndex: signInScreenIndex,
                            ))))
                : setState(() {
                    selectedOption = 3;
                  });
          },
        )
      ]),
    );
  }
}

class AllPlants {}
