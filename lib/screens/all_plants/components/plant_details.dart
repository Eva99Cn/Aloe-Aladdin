import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
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
  Map<dynamic, dynamic> allPlants = {};
  String plantName = "";
  List<String> errors = [];
  int plantId;

  var now = new DateTime.now();
  final _formKey = GlobalKey<FormState>();
  bool isVisibleNewPlantForm = false;
  String addPlantText = "Ajouter";

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

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
                  allPlants = _values;
                } catch (err) {}

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      allPlants["Nom"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenHeight(context, 25),
                        color: Colors.black,
                      ),
                    ),
                    Text(""),
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
                            imageUrl: allPlants["Photo"],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    DefaultButton(
                        text: addPlantText,
                        press: () {
                          if (currentUser != null) {
                            errors.clear();
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
                                        child:
                                            buildPlantNameFormField(context)),
                                    FormError(errors: errors),
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
                                            errors
                                                .remove(kPlantNameExistsError);
                                            databaseReference
                                                .child("Users")
                                                .child(currentUser.uid)
                                                .child(plantName)
                                                .set({
                                              "DateAjout":
                                                  formatter.format(now),
                                              "NomPlante": plantName,
                                              "IdPlante":
                                                  allPlants["Id_Ma_Plante"],
                                              "arrosageDate":
                                                  formatter.format(now),
                                              "prochainArrosage":
                                                  formatter.format(now),
                                            });
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return buildDialogAddPlantSuccess(
                                                      context);
                                                });
                                          } else {
                                            addError(
                                                error: kPlantNameExistsError);
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
                            plantInfo: allPlants["Espèce"],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  " Espèce : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Expanded(
                                    child: Text(
                                  allPlants["Espèce"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenHeight(
                                        context, 14),
                                    color: Colors.black,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    " Fréquence d'arrosage : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                    child: Text(
                                  allPlants["Fréquence_Arrosage"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenHeight(
                                        context, 14),
                                    color: Colors.black,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    " Difficulté d'entretien : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  allPlants["Difficulté_Entretien"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenHeight(
                                        context, 14),
                                    color: Colors.black,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    " Climat : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  allPlants["Climat"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenHeight(
                                        context, 14),
                                    color: Colors.black,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    " Exposition : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  allPlants["Expositon"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenHeight(
                                        context, 14),
                                    color: Colors.black,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  " Saison de semence : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                    child: Text(
                                  allPlants["Saison_Semence"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenHeight(
                                        context, 14),
                                    color: Colors.black,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    " Type de terre : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  allPlants["Terre"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenHeight(
                                        context, 14),
                                    color: Colors.black,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    " Taille à maturité : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  allPlants["Taille_A_Maturité"],
                                  textAlign: TextAlign.center,
                                ))
                              ],
                            ),
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

  TextFormField buildPlantNameFormField(BuildContext context) {
    return TextFormField(
      autofocus: true,
      style: TextStyle(
          fontSize: getProportionateScreenWidth(context, formFontSize)),
      keyboardType: TextInputType.text,
      onSaved: (newValue) => plantName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPlantNameNullError);
        } else if (plantNameValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidPlantNameError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPlantNameNullError);
          return "";
        } else if (!plantNameValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidPlantNameError);
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
}
