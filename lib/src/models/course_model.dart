import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class CourseModel {
  final log = Logger('clubModel');



  String title;
  DateTime start;
  DateTime end;
  String type;
  String location;
  String teacher;
  String description;
  DateTime updated;

  CourseModel({
    this.title,
    this.start,
    this.end,
    this.type,
    this.location,
    this.teacher,
    this.description,
    this.updated
  });

}