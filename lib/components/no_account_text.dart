import 'package:aloe/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pas de compte ?",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(context, 8),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen())),
          child: Text(
            "S'inscrire",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(context, 8),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
