import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PlantDetailsScreen extends StatefulWidget {
  final int plantId;
  const PlantDetailsScreen({Key key, this.plantId}) : super(key: key);
  @override
  _PlantDetailsScreenState createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  Map<dynamic, dynamic> allPlants = {};
  String plantName;
  List<String> errors = [];

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        print(errors);

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
            stream: databaseReference
                .child('AllPlantes')
                .orderByChild("Id_Ma_Plante")
                .equalTo(widget.plantId)
                .onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                allPlants.clear();
                Map<dynamic, dynamic> _values = snapshot.data.snapshot.value;
                _values.forEach((key, value) {
                  allPlants.addAll(value);
                });

                return Column(
                  children: [
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
                        text: "Ajouter cette plante",
                        press: () {
                          errors.clear();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return buildDialogAddPlant(context);
                              });
                        }),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            allPlants["Nom"],
                            style: TextStyle(
                              fontSize:
                                  getProportionateScreenHeight(context, 14),
                              color: Colors.black,
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

  AlertDialog buildDialogAddPlant(BuildContext context) {
    return AlertDialog(
      title: new Text('Ajouter cette plante'),
      actions: <Widget>[
        Form(
            key: _formKey,
            child: Container(
              height: getProportionateScreenWidth(context, 100),
              width: getProportionateScreenWidth(context, 150),
              child: Column(
                children: [
                  Container(
                      height: 100, child: buildPlantNameFormField(context)),
                  FormError(errors: errors),
                  TextButton(
                    child: Text(
                      "OK",
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        print(errors);
                        DataSnapshot snapshot = await databaseReference
                            .child("Users")
                            .child(currentUser.uid)
                            .child(plantName)
                            .once();

                        if (snapshot.value == null) {
                          errors.remove(kInvalidPlantNameError);
                          databaseReference
                              .child("Users")
                              .child(currentUser.uid)
                              .child(plantName)
                              .set({
                            "plantId": allPlants["Id_Ma_Plante"],
                            "arrosageDate": formatter.format(now)
                          });
                          Navigator.pop(context);
                        } else {
                          errors.add(kInvalidPlantNameError);
                        }
                      }
                    },
                  ),
                ],
              ),
            ))
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
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPlantNameNullError);
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
}
