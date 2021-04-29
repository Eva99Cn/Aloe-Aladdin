import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/screens/resetsuccess/resetsuccess.dart';
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
              if (value.isNotEmpty) {
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
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: InkWell(
                  child: Icon(Icons.mail_outline, size: 20), onTap: () {}),
            ),
          ),
          SizedBox(
              height:
                  getProportionateScreenHeight(context, generalPaddingSize)),
          FormError(errors: errors),
          SizedBox(
              height:
                  getProportionateScreenHeight(context, generalPaddingSize)),
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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ResetSuccessScreen()));
    }).catchError((onError) {});
  }
}
