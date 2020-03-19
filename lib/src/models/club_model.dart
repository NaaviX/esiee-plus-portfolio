import 'dart:convert';

import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:logging/logging.dart';

class ClubModel {
  final log = Logger('clubModel');



  int idClubRef;
  String idClub;
  String name;
  String mail;

  int price;
  String contact;
  int solde;
  String description;
  String urlPhoto;
  List<RoleModel> roles;
  List<StudentModel> students;

  bool isAdmin;
  bool isModo;
  bool isTrez;
  bool isLog;

  ClubModel({
    this.idClubRef,
    this.idClub,
    this.name,
    this.mail,
    this.price,
    this.contact,
    this.solde,
    this.description,
    this.urlPhoto,
    this.roles,
    this.students
  });

  factory ClubModel.fromJson(Map<String, dynamic> parsedJson) {
    ClubModel e = new ClubModel();

    if (parsedJson != null) {
      e.idClubRef = parsedJson["idClubRef"];
      e.idClub = parsedJson["idClub"];
      e.name = parsedJson["name"];
      e.mail = parsedJson["mail"];
      if(parsedJson["price"] == null) {
        e.price = 0;
      } else {
        e.price = parsedJson["price"];
      }
      e.contact = parsedJson["contact"];
      if(parsedJson["solde"] == null) {
        e.solde = 0;
      } else {
        e.solde = parsedJson["solde"];
      }

      e.description = parsedJson["description"];
      e.urlPhoto = parsedJson["url_photo"];
      if(e.urlPhoto == null) {
        e.urlPhoto = "";
      }

      e.roles = new List<RoleModel>();
      e.students = new List<StudentModel>();
      e.isAdmin = false;
      e.isTrez = false;
      e.isModo = false;
      e.isLog = false;
      for(dynamic roleFromJson in parsedJson["roles"]) {
        RoleModel role = RoleModel.fromJson(roleFromJson);
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
      for(dynamic studentFromJson in parsedJson["students"]) {
        StudentModel student = StudentModel.fromJson(studentFromJson);
        e.students.add(student);
      }
    }

    return e;
  }

  static List<ClubModel> allClubsFromJson(List<dynamic> jsonData) {
    return new List<ClubModel>.from(
        jsonData.map((x) => ClubModel.fromJson(x)));
  }

}