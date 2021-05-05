import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProfilForm extends StatefulWidget {
  @override
  _ProfilFormState createState() => _ProfilFormState();
}

class _ProfilFormState extends State<ProfilForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formEmailKey = GlobalKey<FormState>();
  final _formPasswordKey = GlobalKey<FormState>();
  List<Map<dynamic, dynamic>> userInfo = [];

  String email;
  String password;
  String conformPassword;
  String oldPassword;
  String newpassword;

  bool isModifyProfil = false;
  bool isModifyEmail = false;
  bool _isModifyPassword = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
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
                FormError(errors: errors),
                Text(
                  "Email" + " : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _auth.currentUser.email,
                  style: TextStyle(color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isModifyEmail = isModifyEmail ? false : true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kSecondaryColor,
                        padding: const EdgeInsets.all(8.0)),
                    child: Text(
                      "Modifier",
                      style: TextStyle(
                        color: Colors.black,
                        //fontSize: getProportionateScreenWidth(context,16),
                      ),
                    ),
                  ),
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
                          //SizedBox(
                          //  height: getProportionateScreenHeight(context,30)),
                          buildModifyEmailPasswordFormField(),
                          // SizedBox(
                          //  height: ),
                          DefaultButton(
                            text: "Continue",
                            press: () {
                              if (_formEmailKey.currentState.validate()) {
                                _formEmailKey.currentState.save();
                                // if all are valid then go to success screen
                                modifyEmail();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text("Mot de passe",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isModifyPassword = _isModifyPassword ? false : true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kSecondaryColor,
                        padding: const EdgeInsets.all(8.0)),
                    child: Text(
                      "Modifier",
                      style: TextStyle(
                        color: Colors.black,
                        //fontSize:,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isModifyPassword,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formPasswordKey,
                      child: Column(
                        children: [
                          buildOldPassFormField(),
                          // SizedBox(
                          //    height: getProportionateScreenHeight(context,30)),
                          buildNewPasswordFormField(),
                          // SizedBox(
                          //    height: getProportionateScreenHeight(context,30)),
                          buildNewConfirmPassFormField(),
                          // SizedBox(
                          //   height: getProportionateScreenHeight(context,30)),
                          DefaultButton(
                            text: "Continue",
                            press: () {
                              if (_formPasswordKey.currentState.validate()) {
                                _formPasswordKey.currentState.save();
                                modifyPassword();
                              }
                            },
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

  TextFormField buildNewConfirmPassFormField() {
    return TextFormField(
      style: TextStyle(
        fontSize: getProportionateScreenWidth(context, 8),
      ),
      obscureText: true,
      onSaved: (newValue) => conformPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && newpassword == conformPassword) {
          removeError(error: kMatchPassError);
        }
        conformPassword = value;
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
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      style: TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
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
        labelText: "Nouveau Email",
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            InkWell(child: Icon(Icons.mail_outline, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildOldPassFormField() {
    return TextFormField(
      style: TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
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
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildModifyEmailPasswordFormField() {
    return TextFormField(
      style: TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
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
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mot de passe",
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outline_rounded, size: 20), onTap: () {}),
      ),
    );
  }

  TextFormField buildNewPasswordFormField() {
    return TextFormField(
      style: TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
      obscureText: true,
      onSaved: (newValue) => newpassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
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
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),
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

              errors.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("EmailChanged"),
                duration: Duration(seconds: 5),
              ));
            }))
        .catchError((err) {
      addError(error: "tryagain");
    });
  }

  Future<void> modifyPassword() async {
    _auth
        .signInWithEmailAndPassword(
            email: _auth.currentUser.email, password: oldPassword)
        .then((value) =>
            _auth.currentUser.updatePassword(newpassword).then((value) {
              setState(() {
                _isModifyPassword = false;
              });
              errors.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("PasswordChanged"),
                duration: Duration(seconds: 5),
              ));
            }))
        .catchError((err) {
      addError(error: "tryagain");
    });
  }
}
