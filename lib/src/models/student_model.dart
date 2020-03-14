import 'dart:convert';

import 'package:bde_esiee_mobile/src/models/role_model.dart';
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
  List<RoleModel> roles;
  bool isAdmin;
  bool isModo;
  bool isLog;
  bool isTrez;




  StudentModel({
    this.id_student,
    this.mailEsiee,
    this.firstname,
    this.lastname,
    this.promo,
    this.phone,
    this.contributor,
    this.urlPhoto,
    this.roles,
    this.isAdmin,
    this.isLog,
    this.isModo,
    this.isTrez
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
      e.roles = new List<RoleModel>();
      e.isAdmin = false;
      e.isTrez = false;
      e.isModo = false;
      e.isLog = false;
      for(dynamic roleFromJson in parsedJson["roles"]) {
        RoleModel role = RoleModel.roleFromJson(roleFromJson);
        e.roles.add(role);
        if(role.role == "admin") {
          e.isAdmin = true;
        } else if(role.role == "trez") {
          e.isTrez = true;
        } else if(role.role == "mod") {
          e.isModo = true;
        } else if(role.role == "log") {
          e.isLog = true;
        }
      }
    }

    return e;
  }

  static List<StudentModel> allStudentsFromJson(List<dynamic> jsonData) {
    return new List<StudentModel>.from(
        jsonData.map((x) => StudentModel.fromJson(x)));
  }



}