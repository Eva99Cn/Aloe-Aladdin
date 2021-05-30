import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/screens/home/home_screen.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String email;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(
                fontSize: getProportionateScreenWidth(context, formFontSize)),
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return null;
            },
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kEmailNullError);
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email" + "*",
              labelStyle: TextStyle(
                  fontSize: getProportionateScreenWidth(context, formFontSize)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: InkWell(
                  child: Icon(Icons.mail_outline, size: 20), onTap: () {}),
            ),
          ),
          FormError(errors: errors),
          DefaultButton(
            text: "Continuer",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                resetPassword();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> resetPassword() async {
    _auth.sendPasswordResetEmail(email: email).then((value) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return buildDialogEmailSent(context);
          });
    }).catchError((onError) {});
  }

  AlertDialog buildDialogEmailSent(BuildContext context) {
    return AlertDialog(
        title: Column(
          children: [
            Icon(
              Icons.mail_rounded,
              size: getProportionateScreenHeight(context, 60),
            ),
            Text(
              "Un email a été envoyé pour changer votre mot de passe",
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "J'ai compris",
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavScreen(
                            startingIndex: homeScreenIndex,
                            selectedWidget: HomeScreen(),
                          )));
            },
          ),
        ]);
  }
}
