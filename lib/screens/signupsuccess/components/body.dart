import 'package:aloe/components/default_button.dart';
import 'package:aloe/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text("Inscription"),
                Text(
                  "Veuillez confirmer votre adresse mail\n N'oubliez pas de vérifier dans vos courrier indésirable",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(28),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                DefaultButton(
                  text: "J'ai compris",
                  press: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
