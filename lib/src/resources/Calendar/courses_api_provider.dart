import 'dart:async';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

import '../../App.dart';

class CoursesApiProvider {
  final log = Logger('TimeCalendar_API_grades');
  final Client client;

  CoursesApiProvider({
    @required this.client,
  }) : assert(client != null);

  Future<List<CourseModel>> fetchCoursesList(String mail) async {
    final response = await client.get(
        "https://ade.wallforfry.fr/v2/agenda/"+mail
    );

    if (response.statusCode == 200) {
      return CourseModel.allCoursesFromJson( json.decode(response.body) as List );
    }
    else {
      throw Exception('Failed');
    }
  }
}
