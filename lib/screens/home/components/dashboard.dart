import 'package:aloe/components/dashbord_button.dart';
import 'package:aloe/constants.dart';
import 'package:aloe/screens/activities/activities_screen.dart';
import 'package:aloe/screens/all_plants/all_plants_screen.dart';
import 'package:aloe/screens/all_plants/components/grid_of_plants.dart';
import 'package:aloe/screens/my_plants/my_plants_screen.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  final Widget selectedWidget;
  const DashBoard({Key key, this.selectedWidget}) : super(key: key);
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Widget selectedOption;
  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedWidget;
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;
    bool isUserSignedIn = currentUser == null;

    return SingleChildScrollView(
        child: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        DashboardButton(
          text: "Toutes les plantes",
          press: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NavScreen(
                          startingIndex: homeScreenIndex,
                          selectedWidget: AllPlantsScreen(
                            selectedWiget: GridOfPlants(),
                          ),
                        )));
          },
        ),
        DashboardButton(
          text: "Mes Plantes",
          press: () {
            isUserSignedIn
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (NavScreen(
                              startingIndex: 2,
                            ))))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavScreen(
                              startingIndex: homeScreenIndex,
                              selectedWidget: MyPlantsScreen(),
                            )));
          },
        ),
        DashboardButton(
          text: "Activités",
          press: () {
            isUserSignedIn
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (NavScreen(
                              startingIndex: signInScreenIndex,
                            ))))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavScreen(
                              startingIndex: homeScreenIndex,
                              selectedWidget: MyActivitiesScreen(),
                            )));
          },
        )
      ]),
    )));
  }
}
