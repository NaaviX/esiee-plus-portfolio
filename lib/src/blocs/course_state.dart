import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:meta/meta.dart';

abstract class CourseState  {
  const CourseState();

}

class CoursesInitial extends CourseState {}

class CoursesLoadInProgress extends CourseState {}

class CoursesLoadSuccess extends CourseState {
  final List<CourseModel> courses;

  const CoursesLoadSuccess({@required this.courses}) : assert(courses != null);

}

class CoursesLoadFailure extends CourseState {}
