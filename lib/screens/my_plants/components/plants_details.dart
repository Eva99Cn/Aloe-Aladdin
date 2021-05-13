import 'dart:collection';

import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PlantDetailsItem extends StatefulWidget {
  final plantInformation;
  const PlantDetailsItem({Key key, this.plantInformation}) : super(key: key);
  @override
  _PlantDetailsItemState createState() => _PlantDetailsItemState();
}

class _PlantDetailsItemState extends State<PlantDetailsItem> {
  LinkedHashMap<dynamic, dynamic> myPlant = new LinkedHashMap();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
            stream: databaseReference
                .child('AllPlantes')
                .orderByChild("Id_Ma_Plante")
                .equalTo(widget.plantInformation['IdPlante'])
                .onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                myPlant.clear();
                try {
                  Map<dynamic, dynamic> _values = snapshot.data.snapshot.value;
                  _values.forEach((key, value) {
                    myPlant.addAll(value);
                  });
                } catch (err) {
                  return Center(
                    child: Column(
                      children: [
                        Text("Pas de plantes ajoutées"),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: kPrimaryColor,
                                padding: const EdgeInsets.all(8.0)),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavScreen(
                                            startingIndex: homeScreenIndex,
                                            widgetIndex: 1,
                                          )));
                            },
                            child: Text("Ajouter des plantes"))
                      ],
                    ),
                  );
                }
                var photoUrl = myPlant['Photo'];

                return (Row(
                  children: [
                    Container(
                      height: getProportionateScreenHeight(context, 70),
                      width: getProportionateScreenWidth(context, 40),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Text(
                          "Loading...",
                          style: TextStyle(fontSize: 20),
                        ),
                        fit: BoxFit.fill,
                        imageUrl: photoUrl,
                      ),
                    ),
                    Column(
                      children: [Text(widget.plantInformation['NomPlante'])],
                    )
                  ],
                ));
              }
              return Container();
            }));
  }
}
