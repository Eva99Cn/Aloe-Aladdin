import 'package:aloe/screens/home/components/dashboard.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final Widget selectedWidget;
  const Body({Key key, this.selectedWidget}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Widget selectedOption;
  @override
  void initState() {
    super.initState();
    selectedOption =
        widget.selectedWidget == null ? DashBoard() : widget.selectedWidget;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SafeArea(
            child: Column(
      children: [DashBoard()],
    )));
  }
}
