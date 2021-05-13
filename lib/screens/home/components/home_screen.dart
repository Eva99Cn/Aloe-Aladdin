import 'package:aloe/screens/home/components/body.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final int widgetIndex;
  const HomeScreen({Key key, this.widgetIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Body(
      widgetIndex: widgetIndex,
    );
  }
}
