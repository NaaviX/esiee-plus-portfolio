import 'dart:convert';
import 'dart:ui';

import 'package:bde_esiee_mobile/src/theme.dart';
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
  String description;
  DateTime updated;
  //Color color;

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
      String date = parsedJson["date"].split("/").reversed.toList().join('-');
      String lastUpdateDate = parsedJson["updated_at"].split(' ')[0].split('/').reversed.toList().join('-');
      //List<String> colors = parsedJson["color"].split(",").reversed.toList();
      e.title = parsedJson["unite_name"];
      e.start = DateTime.parse("$date ${parsedJson["start_hour"]}:00");
      e.end = DateTime.parse("$date ${parsedJson["end_hour"]}:00");
      e.location = parsedJson["classrooms"].toString();
      e.teachers = parsedJson["instructors"].toString();
      e.description = parsedJson["info"];
      e.updated = DateTime.parse("$lastUpdateDate ${parsedJson["updated_at"].split(' ')[1]}");
      e.type = parsedJson["name"].split(":")[1];
      e.type = e.type.replaceAll(" ", "");
      //e.color = Color.fromRGBO( int.parse(colors[0]), int.parse(colors[1]), int.parse(colors[2]), 1.0);
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
    switch (this.type) {
      case "TD":
        return Color(0x6D8CCE).withOpacity(0.7);
      case "TP":
        return Color(0x8A7AD2).withOpacity(0.7);
      case "COURS":
        return PrimaryColor.withOpacity(0.7);
      case "PROJET":
        return Color(0xFF9142).withOpacity(0.7);
      case "CTRL":
        return Color(0xD80230).withOpacity(0.7);
      case "TDR":
        return Colors.blueGrey.withOpacity(0.7);
      case "TDRM":
        return Colors.blueGrey.withOpacity(0.7);
      case "TDRm":
        return Colors.blueGrey.withOpacity(0.7);
      default:
        return Colors.amber.withOpacity(0.8);
    }
  }

}