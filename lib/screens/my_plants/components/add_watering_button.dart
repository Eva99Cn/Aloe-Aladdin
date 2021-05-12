import 'package:aloe/constants.dart';
import 'package:aloe/models/UserPlant.dart';
import 'package:aloe/services/notifications_services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../size_config.dart';

class AddWateringButton extends StatefulWidget {
  final String plantName;
  const AddWateringButton({
    Key key,
    @required this.plantName,
  }) : super(key: key);

  @override
  _AddWateringButtonState createState() => _AddWateringButtonState();
}

class _AddWateringButtonState extends State<AddWateringButton> {
  var formatter = new DateFormat('yyyy-MM-dd hh:mm');
  DateTime initialDate = DateTime.now();

  DateTime choosenDateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    UserPlant userPlant;
    return SafeArea(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () {
            databaseReference
                .child("Users")
                .child(currentUser.uid)
                .child(widget.plantName)
                .once()
                .then((DataSnapshot snapshot) {
              Map<dynamic, dynamic> userPlantInformation = snapshot.value;

              databaseReference
                  .child("AllPlantes")
                  .orderByChild("Id_Ma_Plante")
                  .equalTo(userPlantInformation["IdPlante"])
                  .once()
                  .then((DataSnapshot snapshotPlant) {
                Map<dynamic, dynamic> _values = snapshotPlant.value;
                Map<dynamic, dynamic> plantInformation = _values.values.first;

                userPlant = new UserPlant(
                  userPlantInformation,
                  plantInformation["Fréquence_Arrosage"],
                );
                userPlant.init();
                bottomDatePicker(context, userPlant);
              });
            });
          },
          style: ElevatedButton.styleFrom(
              primary: kPrimaryColor, padding: const EdgeInsets.all(8.0)),
          child: Container(
            width: getProportionateScreenWidth(context, 100),
            child: Row(
              children: [
                Text(
                  "Ajouter un arrosage",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bottomDatePicker(context, UserPlant userPlant) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Container(
              height: getProportionateScreenHeight(context, 280),
              child: Column(
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(context, 200),
                    child: CupertinoDatePicker(
                        initialDateTime: initialDate,
                        maximumDate: initialDate,
                        minimumDate: userPlant.wateringDate,
                        use24hFormat: true,
                        onDateTimeChanged: (dateTime) {
                          setState(() {
                            choosenDateTime = dateTime;
                          });
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            databaseReference
                                .child("Users")
                                .child(currentUser.uid)
                                .child(widget.plantName)
                                .update({
                              "arrosageDate": formatter.format(choosenDateTime)
                            });
                            NotificationService()
                                .scheduleNotificationForNextWatering(userPlant);
                            Navigator.pop(c);
                          },
                          child: Text("Confirmer")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(c);
                          },
                          child: Text("Annuler")),
                    ],
                  )
                ],
              ));
        });
  }
}
