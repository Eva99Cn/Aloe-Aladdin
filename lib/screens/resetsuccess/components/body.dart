import 'package:aloe/components/default_button.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
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
                SizedBox(height: getProportionateScreenHeight(context, 20)),
                Text("Mot de passe oublié"),
                Text(
                  "Un email à été envoyé pour changer votre mot de passe",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(context, 28),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(context, 20)),
                DefaultButton(
                  text: "returnhome",
                  press: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NavScreen(startingIndex: homeScreenIndex)));
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(context, 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
