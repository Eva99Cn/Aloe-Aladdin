import 'package:aloe/components/default_button.dart';
import 'package:aloe/models/UserPlant.dart';
import 'package:aloe/services/notifications_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd hh:mm');
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "ICI page Mes plantes",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(context, 15),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /*
                
                Exemple d'utilisation : à corriger et implémenter implémenter
                */
                DefaultButton(
                  text: "Test notif",
                  press: () {
                    UserPlant userPlant = new UserPlant(
                        "Dave",
                        formatter.parse("2021-05-11 05:09"),
                        "1 fois par semaine",
                        1);
                    NotificationService()
                        .scheduleNotificationForNextWatering(userPlant);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
