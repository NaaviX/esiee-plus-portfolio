import 'dart:async';

import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:meta/meta.dart';

import 'courses_api_provider.dart';


class CoursesRepository {
  final CoursesApiProvider courseApiProvider;

  CoursesRepository({@required this.courseApiProvider})
      : assert(courseApiProvider != null);

  Future<List<CourseModel>> fetchCourses(String mail) async {
    return courseApiProvider.fetchCoursesList(mail);
  }
}