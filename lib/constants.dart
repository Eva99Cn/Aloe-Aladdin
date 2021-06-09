import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xFF16B84E); // Vert principal
const backgroundColor = Color(0xFFF5F5DC); //Beige clair
const style1ButtonColor = Color(0xffC5E1A5);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

String emailNullError = "Veuillez entrer un mail";
String invalidEmailError = "Le mail n'est pas valide";
String passNullError = "Veuillez entrer un mot de passe";
String shortPassError = "Le mot de passe est trop court";
String confirmPassNullError = "Veuillez confirmer votre mot de passe";

String matchPassError = "Les mots de passe ne correspondent pas";
String plantNameNullError = "Veuillez entrer un surnom";
String plantNameExistsError = "Le surnom existe deja";
String invalidPlantNameError =
    "Le surnom ne doit contenir que des lettres, des nombres et ne peut contenir d'espace au début et à la fin";

String tooManyAttemptsError =
    "L'accès à ce compte a été temporairement désactivé en raison de nombreuses tentatives de connexion infructueuses.";
String kWrongPassword = "Le mot de passe n'est pas valide";

final RegExp plantNameValidatorRegExp =
    RegExp(r'^[-a-zA-Z0-9-()]+(\s+[-a-zA-Z0-9-()]+)*$');

DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

int homeScreenIndex = 0;
int newsScreenIndex = 1;
int signInScreenIndex = 2;

double formFontSize = 10;
double bodyFontSize = 10;
double headerFontSize = 28;
double buttonFontSize = 8;

double generalPaddingSize = 20;

var formatter = new DateFormat('yyyy-MM-dd hh:mm');
