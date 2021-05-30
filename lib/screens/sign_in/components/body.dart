import 'package:aloe/components/no_account_text.dart';
import 'package:aloe/constants.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
              height:
                  getProportionateScreenHeight(context, generalPaddingSize)),
          Text(
            "Connexion",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(context, 15),
              fontWeight: FontWeight.bold,
            ),
          ),
          SignForm(),
          NoAccountText(),
        ],
      ),
    );
  }
}
