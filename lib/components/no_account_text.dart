import 'package:aloe/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

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
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen())),
          child: Text(
            "S'inscrire",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
