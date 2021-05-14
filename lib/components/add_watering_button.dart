import 'package:aloe/constants.dart';
import 'package:aloe/models/UserPlant.dart';
import 'package:aloe/services/notifications_services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class AddWateringButton extends StatefulWidget {
  final String plantName;
  final bool isForActivitiesScreen;
  const AddWateringButton(
      {Key key, @required this.plantName, @required this.isForActivitiesScreen})
      : super(key: key);

  @override
  _AddWateringButtonState createState() => _AddWateringButtonState();
}

class _AddWateringButtonState extends State<AddWateringButton> {
  DateTime initialDate = DateTime.now();
  DateTime choosenDateTime = DateTime.now();
  Map<dynamic, dynamic> plantInformation;

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
                plantInformation = _values.values.first;

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
              elevation: 0,
              primary: widget.isForActivitiesScreen
                  ? Colors.transparent
                  : kPrimaryColor,
              padding: const EdgeInsets.all(8.0)),
          child: Container(
            width: getProportionateScreenWidth(context, 100),
            child: widget.isForActivitiesScreen
                ? Icon(
                    Icons.done_outline_sharp,
                    color: Colors.black,
                  )
                : Row(
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
                              "arrosageDate": formatter.format(choosenDateTime),
                              "prochainArrosage": formatter.format(
                                  choosenDateTime.add(Duration(
                                      days:
                                          NotificationService().computeWatering(
                                plantInformation["Fréquence_Arrosage"],
                              ))))
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
