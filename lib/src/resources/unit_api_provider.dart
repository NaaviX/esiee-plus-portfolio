import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';

import '../App.dart';
import 'package:meta/meta.dart';


class UnitApiProvider {
  final log = Logger('unitAPI');
  static const baseUrl = 'http://137.74.197.140:8080/api-2-SNAPSHOT';
  final Client client;

  UnitApiProvider({
    @required this.client,
  }) : assert(client != null);

  Future<List<UnitModel>> fetchUnitsList() async {
    final response = await client.get("$baseUrl/unit/units",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      return UnitModel.allUnitsFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load units');
    }
  }
}