import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/screens/forgot_password/forgot_password_screen.dart';
import 'package:aloe/screens/home/components/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  final List<String> errors = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(
            height: getProportionateScreenHeight(context, 20),
          ),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(context, 20)),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen())),
                child: Text(
                  "Mot de passe oublié" + "?",
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(context, 8),
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          //SizedBox(height: getProportionateScreenHeight(context,20)),
          DefaultButton(
            text: "Se connecter",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                signIn();
              }
            },
          ),
        ],
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
        labelText: "Email",
        labelStyle: TextStyle(
          fontSize: getProportionateScreenWidth(context, 8),
        ),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
          child: Icon(Icons.mail_outline,
              size: MediaQuery.of(context).size.width * 0.05),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(
        fontSize: getProportionateScreenWidth(context, 8),
      ),
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "${("Mot de passe")}",
        labelStyle:
            TextStyle(fontSize: getProportionateScreenWidth(context, 8)),

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
            child: Icon(Icons.lock_outlined,
                size: MediaQuery.of(context).size.width * 0.05),
            onTap: () {}),
      ),
    );
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> signIn() async {
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      if (result.user.emailVerified) {
        if (result.user.uid != "DNrxNkfOjeZmJcFLIBpnDjMdbYa2") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } else {
        addError(
            error: "Mail non vérifié, nouveau mail de vérification envoyé");
        result.user.sendEmailVerification();
      }
    }).catchError((err) {
      setState(() {
        addError(
            error:
                "Il y a eu une erreur \nlors de l'authentification \nveuillez réessayer !");
      });
    });
  }
}
