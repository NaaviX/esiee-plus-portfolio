import 'dart:async';
import 'package:bde_esiee_mobile/src/models/grades_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class GradesApiProvider {
  final log = Logger('TimeCalendar_API_grades');
  Client client = Client();

  Future<List<GradesModel>> fetchGradesList() async {
    final response = await client.get("https://api.timecalendar.app/schools/esiee/grades");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return GradesModel.allGradesFromJson(
          json.decode(response.body) as List);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load grades');
    }
  }
}
