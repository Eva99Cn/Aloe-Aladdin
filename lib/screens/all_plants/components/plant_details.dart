import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/plant_information_row.dart';
import 'package:aloe/components/return_button.dart';
import 'package:aloe/components/second_button.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PlantDetailsScreen extends StatefulWidget {
  final int plantId;
  const PlantDetailsScreen({Key key, this.plantId}) : super(key: key);
  @override
  _PlantDetailsScreenState createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  Map<dynamic, dynamic> plantInformation = {};
  String plantName = "";
  int plantId;

  var now = new DateTime.now();
  final _formKey = GlobalKey<FormState>();
  bool isVisibleNewPlantForm = false;
  String addPlantText = "Ajouter";
  String error = "";

  @override
  void initState() {
    super.initState();
    plantId = widget.plantId - 1;
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
                      plantInformation["Nom"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenHeight(context, 25),
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
                    DefaultButton(
                        text: addPlantText,
                        press: () {
                          setError("");
                          if (currentUser != null) {
                            setAddPlantButtonText();
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (NavScreen(
                                          startingIndex: signInScreenIndex,
                                        ))));
                          }
                        }),
                    Visibility(
                        visible: isVisibleNewPlantForm,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                              key: _formKey,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                        height: 100,
                                        child: buildPlantNameFormField()),
                                    Row(
                                      children: [
                                        Visibility(
                                          visible: error != "" ? true : false,
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(
                                          width: getProportionateScreenWidth(
                                              context, generalPaddingSize),
                                        ),
                                        Expanded(
                                          child: Text(error,
                                              style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        context, 10),
                                              )),
                                        )
                                      ],
                                    ),
                                    SecondButton(
                                      press: () async {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          DataSnapshot snapshot =
                                              await databaseReference
                                                  .child("Users")
                                                  .child(currentUser.uid)
                                                  .child(plantName)
                                                  .once();

                                          if (snapshot.value == null) {
                                            setError("");

                                            databaseReference
                                                .child("Users")
                                                .child(currentUser.uid)
                                                .child(plantName)
                                                .set({
                                              "DateAjout":
                                                  formatter.format(now),
                                              "NomPlante": plantName,
                                              "IdPlante": plantInformation[
                                                  "Id_Ma_Plante"],
                                            });
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return buildDialogAddPlantSuccess(
                                                      context);
                                                });
                                          } else {
                                            setError(kPlantNameExistsError);
                                          }
                                        }
                                      },
                                      text: "Ajouter",
                                    ),
                                  ],
                                ),
                              )),
                        )),
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

  AlertDialog buildDialogAddPlantSuccess(BuildContext context) {
    return AlertDialog(
      title: new Text('La plante a bien été ajouté'),
      actions: <Widget>[
        TextButton(
          child: Text(
            "OK",
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _formKey.currentState.reset();
            setAddPlantButtonText();
          },
        )
      ],
    );
  }

  TextFormField buildPlantNameFormField() {
    return TextFormField(
      style: TextStyle(
          fontSize: getProportionateScreenWidth(context, formFontSize)),
      keyboardType: TextInputType.text,
      onSaved: (newValue) => plantName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setError("");
        } else if (plantNameValidatorRegExp.hasMatch(value)) {
          setError("");
        }
        plantName = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          setError(kPlantNameNullError);

          return "";
        } else if (!plantNameValidatorRegExp.hasMatch(value)) {
          setError(kInvalidPlantNameError);

          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Surnom de la plante",
        labelStyle: TextStyle(
          fontSize: getProportionateScreenWidth(context, formFontSize),
        ),
      ),
    );
  }

  void setAddPlantButtonText() {
    if (isVisibleNewPlantForm) {
      setState(() {
        addPlantText = "Ajouter";
      });
      isVisibleNewPlantForm = false;
    } else {
      setState(() {
        addPlantText = "Annuler";
      });
      isVisibleNewPlantForm = true;
    }
  }

  void setError(String errorToPrint) {
    setState(() {
      error = errorToPrint;
    });
  }
}
