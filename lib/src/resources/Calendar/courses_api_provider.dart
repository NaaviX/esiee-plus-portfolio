import 'dart:async';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../App.dart';

class CoursesApiProvider {
  final log = Logger('TimeCalendar_API_grades');
  Client client = Client();

  Future<List<CourseModel>> fetchCoursesList() async {
    String userMail = Uri.encodeComponent(Base.thisUser.mailEsiee);
    final response = await client.get(
        "https://ade.wallforfry.fr/v2/agenda/"+userMail
    );

    if (response.statusCode == 200) {
      return CourseModel.allCoursesFromJson( json.decode(response.body) as List );
    }
    else {
      throw Exception('Failed');
    }
  }
}
