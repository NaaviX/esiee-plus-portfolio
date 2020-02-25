import 'package:logging/logging.dart';

class GradesUnitModel {
  final log = Logger('GradesUnit');

  int id;
  String schoolCode;
  String name;

  GradesUnitModel({
    this.id,
    this.schoolCode,
    this.name
  });

  factory GradesUnitModel.fromJson(Map<String, dynamic> parsedJson) {
    GradesUnitModel e = new GradesUnitModel();

    if (parsedJson != null) {
      e.id = parsedJson["id"];
      e.schoolCode = parsedJson["school_code"];
      e.name = parsedJson["name"];
    }
    return e;
  }

  static List<GradesUnitModel> allGradesUnitFromJson(List<dynamic> jsonData) {
    return new List<GradesUnitModel>.from(
        jsonData.map((x) => GradesUnitModel.fromJson(x)));
  }



}