import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/components/returnButton.dart';
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
                print(snapshot.data.snapshot.value);
                try {
                  Map<dynamic, dynamic> _values = snapshot.data.snapshot.value;
                  allPlants = _values;
                } catch (err) {}

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
                        child: Form(
                            key: _formKey,
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                      height: 100,
                                      child: buildPlantNameFormField(context)),
                                  FormError(errors: errors),
                                  TextButton(
                                    child: Text(
                                      "Ajouter à mes plantes",
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        print(errors);
                                        DataSnapshot snapshot =
                                            await databaseReference
                                                .child("Users")
                                                .child(currentUser.uid)
                                                .child(plantName)
                                                .once();

                                        if (snapshot.value == null) {
                                          errors.remove(kPlantNameExistsError);
                                          databaseReference
                                              .child("Users")
                                              .child(currentUser.uid)
                                              .child(plantName)
                                              .set({
                                            "DateAjout": formatter.format(now),
                                            "NomPlante": plantName,
                                            "IdPlante":
                                                allPlants["Id_Ma_Plante"],
                                            "arrosageDate":
                                                formatter.format(now),
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return buildDialogAddPlantSuccess(
                                                    context);
                                              });
                                        } else {
                                          addError(
                                              error: kPlantNameExistsError);
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ))),
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

  AlertDialog buildDialogAddPlantSuccess(BuildContext context) {
    return AlertDialog(
      title: new Text('La plante a bien été ajouté'),
      actions: <Widget>[
        Container(
          height: getProportionateScreenWidth(context, 100),
          width: getProportionateScreenWidth(context, 150),
          child: Column(
            children: [
              TextButton(
                child: Text(
                  "OK",
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _formKey.currentState.reset();
                  setAddPlantButtonText();
                },
              ),
            ],
          ),
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
