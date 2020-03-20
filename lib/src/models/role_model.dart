import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

enum Role { admin, mod, log, trez }



class RoleModel {
  final log = Logger('RoleModel');

  int idRole;
  Role role;

  RoleModel({
    this.idRole,
    this.role
  });

  factory RoleModel.fromJson(Map<String, dynamic> parsedJson) {
    RoleModel e = new RoleModel();

    if (parsedJson != null) {
      e.idRole = parsedJson["idRole"];
      e.role = Role.values.firstWhere((element) => describeEnum(element) == parsedJson["role"]);
    }
    return e;
  }

  static List<RoleModel> allRolesFromJson(List<dynamic> jsonData) {
    return new List<RoleModel>.from(
        jsonData.map((x) => RoleModel.fromJson(x)));
  }

  @override
  bool operator ==(other) {
    return idRole == other.idRole;
  }

  @override
  String toString(){
    return describeEnum(role);
  }


}