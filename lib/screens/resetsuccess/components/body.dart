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
                Text("Mot de passe oublié"),
                Text(
                  "Un email à été envoyé pour changer votre mot de passe",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(28),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                DefaultButton(
                  text: "returnhome",
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
