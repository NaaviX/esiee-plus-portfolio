import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class CourseModel {
  final log = Logger('clubModel');



  String title;
  DateTime start;
  DateTime end;
  String type;
  String location;
  String teachers;
  String description;
  DateTime updated;

  CourseModel({
    this.title,
    this.start,
    this.end,
    this.type,
    this.location,
    this.teachers,
    this.description,
    this.updated
  });

  factory CourseModel.fromJson(Map<String, dynamic> parsedJson) {
    CourseModel e = new CourseModel();

    if (parsedJson != null) {
      e.title = parsedJson["title"];
      e.start = DateTime.fromMillisecondsSinceEpoch(parsedJson["start"]);
      e.end = DateTime.fromMillisecondsSinceEpoch(parsedJson["end"]);
      e.location = parsedJson["location"];
      e.teachers = parsedJson["teachers"].toString();
      e.description = parsedJson["description"];
      e.updated = DateTime.fromMillisecondsSinceEpoch(parsedJson["exportedAt"]);
      e.type = "TD";
    }
    return e;
  }

  static List<dynamic> sortCourses(List<dynamic> jsonData) {
    DateTime monday = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    DateTime sunday = monday.add(Duration(days: 6));
    jsonData.removeWhere((element) => DateTime.fromMillisecondsSinceEpoch(element["start"]).isAfter(sunday));
    jsonData.removeWhere((element) => DateTime.fromMillisecondsSinceEpoch(element["end"]).isBefore(monday));
  }

  static List<CourseModel> allCoursesFromJson(List<dynamic> jsonData) {
    sortCourses(jsonData);
    return new List<CourseModel>.from(
        jsonData.map((x) => CourseModel.fromJson(x)));
  }

}