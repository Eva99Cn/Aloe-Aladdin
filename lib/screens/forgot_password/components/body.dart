import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/components/no_account_text.dart';
import 'package:aloe/screens/resetsuccess/resetsuccess.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(context, 20)),
              Text(
                "Mot de passe oublié ?",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(context, 28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(context, 10)),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String email;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style:
                TextStyle(fontSize: getProportionateScreenWidth(context, 14)),
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return null;
            },
            validator: (value) {
              if (value.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(
                  fontSize: getProportionateScreenHeight(context, 20)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: InkWell(
                  child: Icon(Icons.mail_outline,
                      size: getProportionateScreenHeight(context, 20)),
                  onTap: () {}),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(context, 30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(context, 10)),
          DefaultButton(
            text: "Continuer",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                resetPassword();
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(context, 20)),
          NoAccountText(),
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
