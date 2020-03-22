import 'dart:ui';

import 'package:flutter/material.dart';
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
      e.type = parsedJson["tags"][0]["name"];
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

  Color get color {
    switch (this.type) {
      case "TD":
        return Color(0x6D8CCE).withOpacity(0.8);
      case "TP":
        return Color(0x8A7AD2).withOpacity(0.8);
      case "CM":
        return Color(0x569B56).withOpacity(0.7);
      case "Projet":
        return Color(0xFF9142).withOpacity(0.8);
      case "Examen":
        return Color(0xD80230).withOpacity(0.5);
      default:
        return Color(0xFFC840).withOpacity(0.9);
    }
  }

}