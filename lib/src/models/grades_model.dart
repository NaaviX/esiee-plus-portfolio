import 'package:logging/logging.dart';

class GradesModel {
  final log = Logger('Grades');



  int id;
  String schoolCode;
  String name;

  GradesModel({
    this.id,
    this.schoolCode,
    this.name
  });

  factory GradesModel.fromJson(Map<String, dynamic> parsedJson) {
    GradesModel e = new GradesModel();

    if (parsedJson != null) {
      e.id = parsedJson["id"];
      e.schoolCode = parsedJson["school_code"];
      e.name = parsedJson["name"];
    }
    return e;
  }

  static List<GradesModel> allGradesFromJson(List<dynamic> jsonData) {
    return new List<GradesModel>.from(
        jsonData.map((x) => GradesModel.fromJson(x)));
  }



}