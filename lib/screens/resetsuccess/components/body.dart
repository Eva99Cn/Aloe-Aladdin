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
              horizontal:
                  getProportionateScreenWidth(context, generalPaddingSize)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: getProportionateScreenHeight(
                        context, generalPaddingSize)),
                Text(
                  "Mot de passe oublié",
                  style: TextStyle(
                    fontSize:
                        getProportionateScreenWidth(context, headerFontSize),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height: getProportionateScreenHeight(
                        context, generalPaddingSize)),
                Text(
                  "Un email a été envoyé pour changer votre mot de passe",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:
                        getProportionateScreenWidth(context, bodyFontSize),
                  ),
                ),
                SizedBox(
                    height:
                        getProportionateScreenHeight(context, bodyFontSize)),
                DefaultButton(
                  text: "Accueil",
                  press: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NavScreen(startingIndex: homeScreenIndex)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
