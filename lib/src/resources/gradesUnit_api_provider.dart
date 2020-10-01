import 'dart:async';
import 'package:bde_esiee_mobile/src/models/gradesUnit_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class GradesUnitApiProvider {
  final log = Logger('TimeCalendar_API_gradesUnit');

  Client client = Client();

  Future<List<GradesUnitModel>> fetchGradesUnitList(String gradesID) async {
    final response = await client.get("https://api.timecalendar.app/schools/esiee/grades/$gradesID/gradeunits");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return GradesUnitModel.allGradesUnitFromJson(
          json.decode(response.body) as List);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load grades units');
    }
  }
}
