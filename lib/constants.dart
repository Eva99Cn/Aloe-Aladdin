import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF16B84E); // Vert principal
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = Colors.accents;
const kSecondaryColor = Color(0xff09423E); // Vert Foncé
const kTextColor = Color(0xFF757575); // Noir

const kAnimationDuration = Duration(milliseconds: 200);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
String kEmailNullError = "Veuillez entrer un mail";
String kInvalidEmailError = "Le mail n'est pas valide";
String kPassNullError = "Veuillez entrer un mot de passe";
String kShortPassError = "Le mot de passe est trop court";
String kMatchPassError = "Les mots de passes ne correspondent pas";
