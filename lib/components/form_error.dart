import 'package:aloe/constants.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class FormError extends StatelessWidget {
  final List<String> errors;

  const FormError({
    Key key,
    @required this.errors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(errors.length,
            (index) => formErrorText(error: errors[index], context: context)));
  }

  Row formErrorText({String error, BuildContext context}) {
    return Row(
      children: [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        SizedBox(
          width: getProportionateScreenWidth(context, generalPaddingSize),
        ),
        Text(error,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(context, 10),
            )),
      ],
    );
  }
}
