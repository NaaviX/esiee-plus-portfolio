import 'dart:async';
import 'dart:io';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

import '../App.dart';

class RoleApiProvider {
  final log = Logger('roleAPI');
  static const baseUrl = 'http://193.70.84.159:8080/api-1-SNAPSHOT';
  final Client client;

  RoleApiProvider({
    @required this.client,
  }) : assert(client != null);

  Future<List<RoleModel>> fetchRoleList() async {
    final response = await client.get("$baseUrl/role/roles",
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
