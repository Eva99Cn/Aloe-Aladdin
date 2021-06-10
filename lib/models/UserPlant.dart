import '../constants.dart';

class UserPlant {
  final Map<dynamic, dynamic> userPlantInformation;
  String name = "";
  DateTime wateringDate;
  int plantId = 0;
  DateTime acquisitionDate;
  final String wateringRequirements;

  UserPlant(this.userPlantInformation, this.wateringRequirements);

  void init() {
    this.name = userPlantInformation["NomPlante"];
    this.plantId = userPlantInformation["IdPlante"];
    this.acquisitionDate = formatter.parse(userPlantInformation["DateAjout"]);
    if (userPlantInformation["arrosageDate"] != null)
      this.wateringDate = formatter.parse(userPlantInformation["arrosageDate"]);
    else
      this.wateringDate = null;
  }

  void setWateringDate(DateTime newWateringDate) {
    this.wateringDate = newWateringDate;
  }
}
