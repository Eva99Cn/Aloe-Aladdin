import 'package:aloe/components/add_watering_button.dart';
import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/components/plant_information_row.dart';
import 'package:aloe/components/return_button.dart';
import 'package:aloe/components/second_button.dart';
import 'package:aloe/screens/my_plants/components/My_plants_list.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class MyPlantDetailsScreen extends StatefulWidget {
  final int plantId;
  final Map<dynamic, dynamic> userPlant;
  const MyPlantDetailsScreen({Key key, this.plantId, this.userPlant})
      : super(key: key);
  @override
  _MyPlantDetailsScreenState createState() => _MyPlantDetailsScreenState();
}

class _MyPlantDetailsScreenState extends State<MyPlantDetailsScreen> {
  Map<dynamic, dynamic> plantInformation = {};
  String plantName = "";
  List<String> errors = [];
  int plantId;
  Map<dynamic, dynamic> userPlant;

  var now = new DateTime.now();
  final _formKey = GlobalKey<FormState>();
  bool isVisibleNewPlantForm = false;

  @override
  void initState() {
    super.initState();
    plantId = widget.plantId - 1;
    userPlant = widget.userPlant;
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReturnButton(),
        StreamBuilder(
            stream: databaseReference
                .child('AllPlantes')
                .child(plantId.toString())
                .onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                try {
                  Map<dynamic, dynamic> _values = snapshot.data.snapshot.value;
                  plantInformation = _values;
                } catch (err) {}

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      userPlant["NomPlante"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenHeight(context, 25),
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      plantInformation["Nom"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(context, 14),
                        color: Colors.black,
                      ),
                    ),
                    Card(
                      elevation: 0,
                      child: GridTile(
                        child: Container(
                          height: getProportionateScreenHeight(context, 200),
                          width: getProportionateScreenWidth(context, 600),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Text(
                              "Loading...",
                              style: TextStyle(fontSize: 20),
                            ),
                            imageUrl: plantInformation["Photo"],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    (userPlant["arrosageDate"] == null)
                        ? AddWateringButton(
                            plantName: userPlant["NomPlante"],
                            isForActivitiesScreen: false)
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PlantInfoDetails(
                            description: "Espèce : ",
                            plantInfo: plantInformation["Espèce"],
                          ),
                          PlantInfoDetails(
                            description: "Fréquence \nd'arrosage : ",
                            plantInfo: plantInformation["Fréquence_Arrosage"],
                          ),
                          PlantInfoDetails(
                            description: "Difficulté \nd'entretien : ",
                            plantInfo: plantInformation["Difficulté_Entretien"],
                          ),
                          PlantInfoDetails(
                            description: "Climat : ",
                            plantInfo: plantInformation["Climat"],
                          ),
                          PlantInfoDetails(
                            description: "Exposition : ",
                            plantInfo: plantInformation["Expositon"],
                          ),
                          PlantInfoDetails(
                            description: "Saison de \nsemence : ",
                            plantInfo: plantInformation["Saison_Semence"],
                          ),
                          PlantInfoDetails(
                            description: "Type de \nTerre : ",
                            plantInfo: plantInformation["Terre"],
                          ),
                          PlantInfoDetails(
                            description: "Taille à \nmaturité : ",
                            plantInfo: plantInformation["Taille_A_Maturité"],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            }),
      ],
    );
  }
}
