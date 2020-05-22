import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';


class UnitApiProvider {
  final log = Logger('unitAPI');
  Client client = Client();

  Future<List<UnitModel>> fetchUnitsList() async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/unit/units");
    if (response.statusCode == 200) {
      return UnitModel.allUnitsFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load post');
    }
  }
}