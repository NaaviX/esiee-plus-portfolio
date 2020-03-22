import 'package:logging/logging.dart';

class GradesUnitModel {
  final log = Logger('GradesUnit');

  int id;
  String name;
  String section;

  GradesUnitModel({
    this.id,
    this.name,
    this.section
  });

  factory GradesUnitModel.fromJson(Map<String, dynamic> parsedJson) {
    GradesUnitModel e = new GradesUnitModel();

    if (parsedJson != null) {
      e.id = parsedJson["id"];
      e.name = parsedJson["name"];
      e.section = parsedJson["typeunit_name"];
    }
    return e;
  }

  static List<GradesUnitModel> allGradesUnitFromJson(List<dynamic> jsonData) {
    return new List<GradesUnitModel>.from(
        jsonData.map((x) => GradesUnitModel.fromJson(x)));
  }



}