import 'package:flutter/material.dart';

import 'components/body.dart';

class AllPlantsScreen extends StatelessWidget {
  final Widget selectedWiget;
  const AllPlantsScreen({Key key, this.selectedWiget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Body(
      selectedWiget: this.selectedWiget,
    );
  }
}
