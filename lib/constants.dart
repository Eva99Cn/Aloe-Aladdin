import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF16B84E); // Vert principal
const kBackgroundColor = Color(0xFFF5F5DC); //Beige clair
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
String kPlantNameNullError = "Veuillez entrer un surnom";
String kPlantNameExistsError = "Le surnom existe deja";
String kInvalidPlantNameError =
    "Le surnom ne doit contenir que des lettres, des nombres et ne peut contenir d'espace";

final RegExp plantNameValidatorRegExp = RegExp(r'^[a-zA-Z0-9]+$');

User currentUser = FirebaseAuth.instance.currentUser;
DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

int homeScreenIndex = 0;
int newsScreenIndex = 1;
int signInScreenIndex = 2;

double formFontSize = 12;
double bodyFontSize = 12;
double headerFontSize = 28;

double generalPaddingSize = 20;
