import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/screens/home/home_screen.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String email;
  String password;
  String confirmPassword;

  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    setState(() {
      errors.remove(error);
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
              SizedBox(
                  height: getProportionateScreenHeight(
                      context, generalPaddingSize)),
              buildEmailFormField(),
              SizedBox(
                  height: getProportionateScreenHeight(
                      context, generalPaddingSize)),
              buildPasswordFormField(),
              SizedBox(
                  height: getProportionateScreenHeight(
                      context, generalPaddingSize)),
              buildConformPassFormField(),
              SizedBox(
                  height: getProportionateScreenHeight(
                      context, generalPaddingSize)),
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
      style: TextStyle(
          fontSize: getProportionateScreenWidth(context, formFontSize)),
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kConfirmPassNullError);
        }
        if (password == confirmPassword) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kConfirmPassNullError);
          return "";
        } else if (password != value) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirmer le mot de passe" + "*",
        labelStyle: TextStyle(
            fontSize: getProportionateScreenWidth(context, formFontSize)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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
          return "";
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
        suffixIcon:
            InkWell(child: Icon(Icons.mail_outline, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(
          fontSize: getProportionateScreenWidth(context, formFontSize)),
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mot de passe" + "*",
        labelStyle: TextStyle(
            fontSize: getProportionateScreenWidth(context, formFontSize)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  Future<void> signUp() async {
    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      result.user.sendEmailVerification();
      _auth.signOut();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return buildDialogSignUpSuccess(context);
          });
    }).catchError((err) {
      if (err.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        addError(error: "Email déja utilisé");
      } else {
        addError(error: "Il y a eu une erreur, rééssayez");
      }
    });
  }

  AlertDialog buildDialogSignUpSuccess(BuildContext context) {
    return AlertDialog(
        title: Column(
          children: [
            Icon(
              Icons.thumb_up_sharp,
              size: getProportionateScreenHeight(context, 60),
            ),
            Text(
              "Veuillez confirmer votre adresse mail. N'oubliez pas de vérifier dans vos courriers indésirables",
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
