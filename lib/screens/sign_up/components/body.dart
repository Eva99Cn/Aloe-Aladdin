import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'sign_up_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 15)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: getProportionateScreenHeight(context, 40)), // 4%
                Text(
                  "Créer un compte",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(context, 28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(context, 40)),
                SignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
