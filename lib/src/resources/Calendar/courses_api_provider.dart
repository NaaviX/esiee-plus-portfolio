import 'dart:async';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class CoursesApiProvider {
  final log = Logger('TimeCalendar_API_grades');
  Client client = Client();

  Future<List<CourseModel>> fetchCoursesList(String ids) async {
    List<String> units_ids = ids.split("-");
    final response = await client.post(
      "https://api.timecalendar.app/calendar",
      body: json.encode({'ids': units_ids}),
      headers: {"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
      return CourseModel.allCoursesFromJson( json.decode(response.body) as List );
    }
    else {
      throw Exception('Failed');
    }
  }
}
