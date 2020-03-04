import 'dart:async';

import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/models/gradesUnit_model.dart';
import 'package:bde_esiee_mobile/src/models/grades_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/resources/grades_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/student_api_provider.dart';
import 'club_api_provider.dart';
import 'event_api_provider.dart';
import 'gradesUnit_api_provider.dart';

class Repository {
  static String gradesID;
  Repository({gradesID});

  final eventsApiProvider = EventApiProvider();
  Future<List<EventModel>> fetchAllEvents() => eventsApiProvider.fetchEventList();
  Future addSaveEvent(String title) => eventsApiProvider.addEvent(title);

  final clubsApiProvider = ClubApiProvider();
  Future<List<ClubModel>> fetchAllClubs() => clubsApiProvider.fetchClubList();

  final studentApiProvider = StudentApiProvider();
  Future<List<StudentModel>> fetchAllStudents() =>
      studentApiProvider.fetchStudentList();
  Future<StudentModel> fetchStudent(String mailEsiee) =>
      studentApiProvider.fetchStudent(mailEsiee);

  final gradesApiProvider = GradesApiProvider();
  Future<List<GradesModel>> fetchAllGrades() => gradesApiProvider.fetchGradesList();

  final gradesUnitApiProvider = GradesUnitApiProvider();
  Future<List<GradesUnitModel>> fetchAllGradesUnit(String gradesID) => gradesUnitApiProvider.fetchGradesUnitList(gradesID);

}
