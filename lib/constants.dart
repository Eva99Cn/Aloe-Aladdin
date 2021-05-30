import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kPrimaryColor = Color(0xFF16B84E); // Vert principal
const kBackgroundColor = Color(0xFFF5F5DC); //Beige clair
const kStyle1ButtonColor = Color(0xffC5E1A5);
const kSecondaryColor = Color(0xff09423E); // Vert Foncé
const kTextColor = Color(0xFF757575); // Noir

const kAnimationDuration = Duration(milliseconds: 200);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

String kEmailNullError = "Veuillez entrer un mail";
String kInvalidEmailError = "Le mail n'est pas valide";
String kPassNullError = "Veuillez entrer un mot de passe";
String kShortPassError = "Le mot de passe est trop court";
String kConfirmPassNullError = "Veuillez confirmer votre mot de passe";

String kMatchPassError = "Les mots de passe ne correspondent pas";
String kPlantNameNullError = "Veuillez entrer un surnom";
String kPlantNameExistsError = "Le surnom existe deja";
String kInvalidPlantNameError =
    "Le surnom ne doit contenir que des lettres, des nombres et ne peut contenir d'espace";

String kTooManyAttempts =
    "L'accès à ce compte a été temporairement désactivé en raison de nombreuses tentatives de connexion infructueuses.";
String kWrongPassword = "Le mot de passe n'est pas valide";

final RegExp plantNameValidatorRegExp = RegExp(r'^[a-zA-Z0-9]+$');

DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

int homeScreenIndex = 0;
int newsScreenIndex = 1;
int signInScreenIndex = 2;

double formFontSize = 10;
double bodyFontSize = 12;
double headerFontSize = 28;
double buttonFontSize = 8;

double generalPaddingSize = 20;

var formatter = new DateFormat('yyyy-MM-dd hh:mm');
