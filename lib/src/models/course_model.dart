import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseModel {
  final log = Logger('clubModel');

  String title;
  DateTime start;
  DateTime end;
  String type;
  String location;
  String teachers;
  String unite;
  String group;
  DateTime updated;
  //Color color;

  CourseModel({
    this.title,
    this.start,
    this.end,
    this.type,
    this.location,
    this.teachers,
    this.unite,
    this.group,
    this.updated
  });

  factory CourseModel.fromJson(Map<String, dynamic> parsedJson) {
    CourseModel e = new CourseModel();

    if (parsedJson != null) {
      String date = parsedJson["date"].split("/").reversed.toList().join('-');
      String lastUpdateDate = parsedJson["updated_at"].split(' ')[0].split('/').reversed.toList().join('-');
      //List<String> colors = parsedJson["color"].split(",").reversed.toList();
      e.title = parsedJson["unite_name"];
      e.start = DateTime.parse("$date ${parsedJson["start_hour"]}:00");
      e.end = DateTime.parse("$date ${parsedJson["end_hour"]}:00");
      e.location = parsedJson["classrooms"].toString();
      e.teachers = parsedJson["instructors"].toString();
      e.unite = parsedJson["unite"];
      e.group = parsedJson["trainees"].toString().replaceAll("[", "").replaceAll("]", "");
      e.updated = DateTime.parse("$lastUpdateDate ${parsedJson["updated_at"].split(' ')[1]}");
      e.type = parsedJson["name"].split(":")[1].replaceAll(" ", "");
    }
    return e;
  }

  static void sortCourses(List<dynamic> jsonData) {
    DateTime monday = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    DateTime sunday = monday.add(Duration(days: 6));
    jsonData.removeWhere((element) => DateTime.fromMillisecondsSinceEpoch(element["start"]).isAfter(sunday));
    jsonData.removeWhere((element) => DateTime.fromMillisecondsSinceEpoch(element["end"]).isBefore(monday));
  }

  static void saveJsonLocal(List<dynamic> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("coursesJson", json.encode(value));
  }

  static List<CourseModel> allCoursesFromJson(List<dynamic> jsonData) {
    saveJsonLocal(jsonData);
    return new List<CourseModel>.from(
        jsonData.map((x) => CourseModel.fromJson(x)));
  }

  Color get color {
    return this.type.toUpperCase().contains("CTRL") | this.type.toUpperCase().contains("NOT") | this.type.toUpperCase().contains("SOUTENANCE") ? Color(0xD80230).withOpacity(0.5) :
    this.type.toUpperCase().contains("TD") ? Color(0x6D8CCE).withOpacity(0.7) :
    this.type.toUpperCase().contains("TP") ? Color(0x8A7AD2).withOpacity(0.7) :
    this.type.toUpperCase().contains("COURS") ? Color(0x569B56).withOpacity(0.6) :
    Color(0xFFC840).withOpacity(0.7);
  }
}