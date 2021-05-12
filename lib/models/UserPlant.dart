import 'package:intl/intl.dart';

class UserPlant {
  final Map<dynamic, dynamic> userPlantInformation;
  String name = "";
  DateTime wateringDate = null;
  int plantId = 0;
  DateTime acquisitionDate = null;
  final String wateringRequirements;

  UserPlant(this.userPlantInformation, this.wateringRequirements);

  void init() {
    var formatter = new DateFormat('yyyy-MM-dd hh:mm');

    this.name = userPlantInformation["NomPlante"];
    this.plantId = userPlantInformation["IdPlante"];
    this.acquisitionDate = formatter.parse(userPlantInformation["DateAjout"]);
    this.wateringDate = formatter.parse(userPlantInformation["arrosageDate"]);
  }
}
