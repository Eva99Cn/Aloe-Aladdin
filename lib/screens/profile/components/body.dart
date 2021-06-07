import 'package:aloe/screens/profile/components/email_change_form.dart';
import 'package:aloe/screens/profile/components/logout.dart';
import 'package:aloe/screens/profile/components/password_change_form.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          EmailChangeForm(),
          PasswordChangeForm(),
          LogOut(),
        ],
      ),
    );
  }
}
