import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DashboardButton extends StatelessWidget {
  const DashboardButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
      child: SizedBox(
        width: getProportionateScreenWidth(context, 250),
        height: getProportionateScreenHeight(context, 100),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(context, bodyFontSize),
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
