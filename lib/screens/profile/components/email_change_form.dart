import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/components/second_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class EmailChangeForm extends StatefulWidget {
  @override
  _EmailChangeFormState createState() => _EmailChangeFormState();
}

class _EmailChangeFormState extends State<EmailChangeForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formEmailKey = GlobalKey<FormState>();
  List<Map<dynamic, dynamic>> userInfo = [];

  String email;
  String password;

  bool isModifyEmail = false;
  final List<String> errorsEmailForm = [];

  void addError({String error}) {
    if (isModifyEmail) {
      if (!errorsEmailForm.contains(error)) {
        setState(() {
          errorsEmailForm.add(error);
        });
      }
    }
  }

  void removeError({String error}) {
    if (isModifyEmail) {
      if (errorsEmailForm.contains(error)) {
        setState(() {
          errorsEmailForm.remove(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Email : ",
                  style: TextStyle(
                      fontSize:
                          getProportionateScreenWidth(context, bodyFontSize),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  _auth.currentUser.email,
                  style: TextStyle(
                    fontSize:
                        getProportionateScreenWidth(context, formFontSize),
                  ),
                ),
                DefaultButton(
                  press: () {
                    setState(() {
                      isModifyEmail = isModifyEmail ? false : true;
                    });
                    errorsEmailForm.clear();
                  },
                  text: "Modifier",
                ),
                Visibility(
                  visible: isModifyEmail,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formEmailKey,
                      child: Column(
                        children: [
                          buildEmailFormField(),
                          buildPasswordFormField(),
                          FormError(errors: errorsEmailForm),
                          SecondButton(
                            press: () {
                              if (_formEmailKey.currentState.validate()) {
                                _formEmailKey.currentState.save();
                                modifyEmail();
                              }
                            },
                            text: "Valider",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          removeError(error: emailNullError);
        }
        if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: invalidEmailError);
        }

        email = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: emailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: invalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nouveau Email",
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
          removeError(error: passNullError);
        }
        if (value.length >= 8) {
          removeError(error: shortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: passNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: shortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mot de passe",
        labelStyle: TextStyle(
            fontSize: getProportionateScreenWidth(context, formFontSize)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  Future<void> modifyEmail() async {
    _auth
        .signInWithEmailAndPassword(
            email: _auth.currentUser.email, password: password)
        .then((value) => _auth.currentUser.updateEmail(email).then((value) {
              _auth.currentUser.sendEmailVerification();

              setState(() {
                isModifyEmail = false;
              });

              errorsEmailForm.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("L'Email à bien été modifié"),
                duration: Duration(seconds: 5),
              ));
            }))
        .catchError((err) {
      if (err.toString() ==
          "[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.") {
        addError(error: tooManyAttemptsError);
      } else if (err.toString() ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        addError(error: kWrongPassword);
      }
    });
  }
}
