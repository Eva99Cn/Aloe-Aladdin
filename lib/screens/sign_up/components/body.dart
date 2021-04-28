import 'package:aloe/constants.dart';
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
              horizontal:
                  getProportionateScreenWidth(context, generalPaddingSize)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: getProportionateScreenHeight(
                        context, generalPaddingSize)), // 4%
                Text(
                  "Créer un compte",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        getProportionateScreenWidth(context, headerFontSize),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height: getProportionateScreenHeight(
                        context, generalPaddingSize)),
                SignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
