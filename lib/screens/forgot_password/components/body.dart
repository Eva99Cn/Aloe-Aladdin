import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'forgot_password_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                "Mot de passe oublié ?",
                style: TextStyle(
                  fontSize:
                      getProportionateScreenWidth(context, headerFontSize),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}
