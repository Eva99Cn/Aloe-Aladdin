import 'package:aloe/components/return_button.dart';
import 'package:flutter/material.dart';

import 'activities_list.dart';

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
                    Navigator.pop(context);
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Mes activités"),
                  ),
                  ActivitiesList(),
                ],
              ),
            )),
      ),
    );
  }
}
