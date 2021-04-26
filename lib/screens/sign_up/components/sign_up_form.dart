import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/screens/signupsuccess/signupsuccess.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("Users");
  DatabaseReference databaseReference1 = FirebaseDatabase.instance.reference();
  String email;
  String password;
  String conformPassword;

  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(context, 30)),
              buildEmailFormField(),
              SizedBox(height: getProportionateScreenHeight(context, 30)),
              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(context, 30)),
              buildConformPassFormField(),
              SizedBox(height: getProportionateScreenHeight(context, 30)),
              FormError(errors: errors),
              DefaultButton(
                text: "S'inscrire",
                press: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    signUp();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      style: TextStyle(fontSize: getProportionateScreenWidth(context, 12)),
      obscureText: true,
      onSaved: (newValue) => conformPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conformPassword) {
          removeError(error: kMatchPassError);
        }
        conformPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirmer le mot de passe" + "*",
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      style: TextStyle(fontSize: getProportionateScreenWidth(context, 12)),
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "kEmailNullError");
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: "kInvalidEmailError");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "kSecreyKeyNullError");
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: "kInvalidEmailError");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email" + "*",
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            InkWell(child: Icon(Icons.mail_outline, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(fontSize: getProportionateScreenWidth(context, 12)),
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: "kShortPassError");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mot de passe" + "*",
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> signUp() async {
    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      result.user.sendEmailVerification();
      databaseReference.child(result.user.uid).set({
        'email': email,
      });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => SignUpSuccessScreen()));
    }).catchError((err) {});
  }
}
