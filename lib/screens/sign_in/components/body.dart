import 'package:aloe/components/no_account_text.dart';
import 'package:flutter/material.dart';

import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                //SizedBox(height: SizeConfig.screenHeight * 0.08),
                // SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
