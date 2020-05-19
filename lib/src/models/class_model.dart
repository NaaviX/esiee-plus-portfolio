import 'package:logging/logging.dart';

class ClassModel {
  final log = Logger('ClassModel');



  int idClass;
  String nom;




  ClassModel({
    this.idClass,
    this.nom
  });

  factory ClassModel.fromJson(Map<String, dynamic> parsedJson) {
    ClassModel e = new ClassModel();

    if (parsedJson != null) {
      e.idClass = parsedJson["idClass"];
      e.nom = parsedJson["nom"];
    }

    return e;
  }

  static ClassModel classFromJson(dynamic jsonData) {
    return new ClassModel.fromJson(jsonData);
  }



}