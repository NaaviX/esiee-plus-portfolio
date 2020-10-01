import 'dart:async';
import 'dart:io';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

import '../App.dart';

class RoleApiProvider {
  final log = Logger('roleAPI');
  Client client = Client();

  Future<List<RoleModel>> fetchRoleList() async {
    final response = await client.get("http://137.74.197.140:8080/api-2-SNAPSHOT/role/roles",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });


    if (response.statusCode == 200) {
      return RoleModel.allRolesFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load user');
    }
  }
}
