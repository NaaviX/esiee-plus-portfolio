import 'dart:convert';

import 'package:logging/logging.dart';

class StudentModel {
  final log = Logger('StudentModel');



  int id_student;
  String mailEsiee;
  String firstname;
  String lastname;
  String promo;
  String phone;
  bool contributor;
  String urlPhoto;


  StudentModel({
    this.id_student,
    this.mailEsiee,
    this.firstname,
    this.lastname,
    this.promo,
    this.phone,
    this.contributor,
    this.urlPhoto
  });

  factory StudentModel.fromJson(Map<String, dynamic> parsedJson) {
    StudentModel e = new StudentModel();

    if (parsedJson != null) {
      e.id_student = parsedJson["id_student"];


      e.mailEsiee = parsedJson["mailEsiee"];
      e.firstname = parsedJson["firstname"];
      e.lastname = parsedJson["lastname"];
      e.promo = parsedJson["promo"];
      e.phone = parsedJson["phone"];
      e.contributor = parsedJson["contributor"];
      e.urlPhoto = parsedJson["urlPhoto"];
    }

    return e;
  }

  static List<StudentModel> allStudentsFromJson(List<dynamic> jsonData) {
    return new List<StudentModel>.from(
        jsonData.map((x) => StudentModel.fromJson(x)));
  }



}