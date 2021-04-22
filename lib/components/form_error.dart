import 'package:flutter/material.dart';

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
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Text(error,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            )),
      ],
    );
  }
}
