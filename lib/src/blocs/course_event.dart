import 'package:flutter/cupertino.dart';

abstract class CourseEvent {
  const CourseEvent();
}


class CoursesRequested extends CourseEvent {

  final String mail;
  const CoursesRequested({@required this.mail}) : assert(mail != null);

}