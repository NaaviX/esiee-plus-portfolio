import 'dart:convert';

import 'package:logging/logging.dart';

class RoleModel {
  final log = Logger('RoleModel');



  int idRole;
  String role;




  RoleModel({
    this.idRole,
    this.role
  });

  factory RoleModel.fromJson(Map<String, dynamic> parsedJson) {
    RoleModel e = new RoleModel();

    if (parsedJson != null) {
      e.idRole = parsedJson["idRole"];
      e.role = parsedJson["role"];
    }

    return e;
  }

  static RoleModel roleFromJson(dynamic jsonData) {
    return new RoleModel.fromJson(jsonData);
  }



}