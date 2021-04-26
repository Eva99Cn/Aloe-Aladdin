import 'package:aloe/components/no_account_text.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
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
                SizedBox(height: getProportionateScreenHeight(context, 20)),
                Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(context, 15),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SignForm(),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
