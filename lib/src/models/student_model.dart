import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:logging/logging.dart';

class StudentModel {
  final log = Logger('StudentModel');



  int idStudent;
  String mailEsiee;
  String firstname;
  String lastname;
  String promo;
  String phone;
  bool contributor;
  String urlPhoto;
  List<RoleModel> roles;




  StudentModel({
    this.idStudent,
    this.mailEsiee,
    this.firstname,
    this.lastname,
    this.promo,
    this.phone,
    this.contributor,
    this.urlPhoto,
    this.roles,
  });

  factory StudentModel.fromJson(Map<String, dynamic> parsedJson) {
    StudentModel e = new StudentModel();

    if (parsedJson != null) {
      e.idStudent = parsedJson["idStudent"];
      e.mailEsiee = parsedJson["mailEsiee"];
      e.firstname = parsedJson["firstname"];
      e.lastname = parsedJson["lastname"];
      e.promo = parsedJson["promo"];
      e.phone = parsedJson["phone"];
      e.contributor = parsedJson["contributor"];
      e.urlPhoto = parsedJson["urlPhoto"];
      e.roles = RoleModel.allRolesFromJson(parsedJson["roles"]);
    }

    return e;
  }

  static List<StudentModel> allStudentsFromJson(List<dynamic> jsonData) {
    return new List<StudentModel>.from(
        jsonData.map((x) => StudentModel.fromJson(x)));
  }



}