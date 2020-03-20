import 'dart:async';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/models/grades_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class CoursesApiProvider {
  final log = Logger('TimeCalendar_API_grades');
  Client client = Client();

  Future<List<CourseModel>> fetchCoursesList() async {
    List<String> ids = ["299","303"];
    final response = await client.post(
      "https://api.timecalendar.app/calendar",
      body: json.encode({'ids':ids}),
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
