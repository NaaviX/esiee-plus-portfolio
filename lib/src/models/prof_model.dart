import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/models/user_model.dart';
import 'package:logging/logging.dart';

import 'class_model.dart';

class ProfModel extends UserModel {
  final log = Logger('ProfModel');

  int idProf;
  String firstname;
  String lastname;
  String mailEsiee;
  String office;
  String phone;
  String urlPhoto;
  List<ClassModel> classes;
  List<UnitModel> units;

  ProfModel({
    this.idProf,
    this.firstname,
    this.lastname,
    this.mailEsiee,
    this.office,
    this.phone,
    this.urlPhoto,
    this.classes,
    this.units,
  });

  factory ProfModel.fromJson(Map<String, dynamic> parsedJson) {
    ProfModel e = new ProfModel();

    if (parsedJson != null) {
      e.idProf = parsedJson["idProf"];
      e.firstname = parsedJson["firstname"];
      e.lastname = parsedJson["lastname"];
      e.mailEsiee = parsedJson["mailEsiee"];
      e.office = parsedJson["office"];
      e.phone = parsedJson["phone"];
      e.urlPhoto = parsedJson["urlPhoto"];
      if(e.urlPhoto == null) {
        e.urlPhoto = "";
      }

      e.classes = new List<ClassModel>();
      for(dynamic classFromJson in parsedJson["classes"]) {
        ClassModel classe = ClassModel.classFromJson(classFromJson);
        e.classes.add(classe);
      }
      e.units = new List<UnitModel>();
      for(dynamic unitFromJson in parsedJson["units"]) {
        UnitModel unit = UnitModel.unitFromJson(unitFromJson);
        e.units.add(unit);
      }
    }

    return e;
  }

  static List<ProfModel> allProfsFromJson(List<dynamic> jsonData) {
    return new List<ProfModel>.from(
        jsonData.map((x) => ProfModel.fromJson(x)));
  }



}