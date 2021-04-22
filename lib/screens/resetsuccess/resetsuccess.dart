import 'package:flutter/material.dart';

import 'components/body.dart';

class ResetSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Mot de passe oublié'),
      ),
      body: Body(),
    );
  }
}
