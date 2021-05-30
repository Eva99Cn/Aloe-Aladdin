import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({Key key, this.press}) : super(key: key);
  final Function press;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: press,
    );
  }
}
