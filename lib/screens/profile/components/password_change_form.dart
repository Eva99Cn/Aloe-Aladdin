import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/components/second_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PasswordChangeForm extends StatefulWidget {
  @override
  _PasswordChangeFormState createState() => _PasswordChangeFormState();
}

class _PasswordChangeFormState extends State<PasswordChangeForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formPasswordKey = GlobalKey<FormState>();
  List<Map<dynamic, dynamic>> userInfo = [];
  String confirmPassword;
  String oldPassword;
  String newpassword;

  bool isModifyPassword = false;
  final List<String> errorsPasswordForm = [];

  void addError({String error}) {
    if (isModifyPassword) {
      if (!errorsPasswordForm.contains(error)) {
        setState(() {
          errorsPasswordForm.add(error);
        });
      }
    }
  }

  void removeError({String error}) {
    if (isModifyPassword) {
      if (errorsPasswordForm.contains(error)) {
        setState(() {
          errorsPasswordForm.remove(error);
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
                Text("Mot de passe",
                    style: TextStyle(
                        fontSize:
                            getProportionateScreenWidth(context, bodyFontSize),
                        fontWeight: FontWeight.bold)),
                DefaultButton(
                  press: () {
                    setState(() {
                      isModifyPassword = isModifyPassword ? false : true;
                    });
                    errorsPasswordForm.clear();
                  },
                  text: "Modifier",
                ),
                Visibility(
                  visible: isModifyPassword,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formPasswordKey,
                      child: Column(
                        children: [
                          buildOldPassFormField(),
                          buildNewPasswordFormField(),
                          buildNewConfirmPassFormField(),
                          FormError(errors: errorsPasswordForm),
                          SecondButton(
                            press: () {
                              if (_formPasswordKey.currentState.validate()) {
                                _formPasswordKey.currentState.save();
                                modifyPassword();
                              }
                            },
                            text: "Valider",
                          )
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

  TextFormField buildNewConfirmPassFormField() {
    return TextFormField(
      style: TextStyle(
        fontSize: getProportionateScreenWidth(context, formFontSize),
      ),
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (newpassword == value) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((newpassword != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirmer le nouveau mot de passe",
        labelStyle: TextStyle(
            fontSize: getProportionateScreenWidth(context, formFontSize)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildOldPassFormField() {
    return TextFormField(
      style: TextStyle(
          fontSize: getProportionateScreenWidth(context, formFontSize)),
      obscureText: true,
      onSaved: (newValue) => oldPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        oldPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Ancien mot de passe",
        labelStyle: TextStyle(
            fontSize: getProportionateScreenWidth(context, formFontSize)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildNewPasswordFormField() {
    return TextFormField(
      style: TextStyle(
          fontSize: getProportionateScreenWidth(context, formFontSize)),
      obscureText: true,
      onSaved: (newValue) => newpassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        newpassword = value;
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
        labelText: "Nouveau mot de passe",
        labelStyle: TextStyle(
            fontSize: getProportionateScreenWidth(context, formFontSize)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  Future<void> modifyPassword() async {
    _auth
        .signInWithEmailAndPassword(
            email: _auth.currentUser.email, password: oldPassword)
        .then((value) =>
            _auth.currentUser.updatePassword(newpassword).then((value) {
              setState(() {
                isModifyPassword = false;
              });
              errorsPasswordForm.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Le mot de passe à bien été modifié"),
                duration: Duration(seconds: 5),
              ));
            }))
        .catchError((err) {
      if (err.toString() ==
          "[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.") {
        addError(error: kTooManyAttempts);
      } else if (err.toString() ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        addError(error: kWrongPassword);
      }
    });
  }
}
