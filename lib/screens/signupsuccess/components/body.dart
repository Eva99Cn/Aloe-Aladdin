import 'package:aloe/components/default_button.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(context, 20),
                ),
                Text(
                  "Inscription",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(context, 20),
                  ),
                ),
                Text(
                  "Veuillez confirmer votre adresse mail\n N'oubliez pas de vérifier dans vos courriers indésirables",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(context, 10),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(context, 20),
                ),
                DefaultButton(
                  text: "J'ai compris",
                  press: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NavScreen()));
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(context, 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
