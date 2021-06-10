import 'package:aloe/components/add_plants_button.dart';
import 'package:aloe/components/return_button.dart';
import 'package:aloe/screens/my_plants/components/my_plants_list.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aloe/constants.dart';
import 'package:page_transition/page_transition.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
                  ReturnButton(press: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: NavScreen(
                              startingIndex: homeScreenIndex,
                            )));
                  }),
                  AddPlantsButton(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Mes plantes"),
                  ),
                  MyPlantsList()
                ],
              ),
            )),
      ),
    );
  }
}
