import 'dart:async';

import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:bde_esiee_mobile/src/models/gradesUnit_model.dart';
import 'package:bde_esiee_mobile/src/models/grades_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/resources/Fairpay/fairpay_log_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/grades_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/prof_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/student_api_provider.dart';
import 'club_api_provider.dart';
import 'event_api_provider.dart';
import 'gradesUnit_api_provider.dart';

class Repository {
  static String gradesID;
  Repository({gradesID});

  final eventsApiProvider = EventApiProvider();
  Future<List<EventModel>> fetchAllEvents() => eventsApiProvider.fetchEventList();
  Future<EventModel> addSaveEvent(EventModel event) => eventsApiProvider.addEvent(event);
  Future<EventModel> updateEvent(EventModel event) => eventsApiProvider.updateEvent(event);

  final clubsApiProvider = ClubApiProvider();
  Future<List<ClubModel>> fetchAllClubs() => clubsApiProvider.fetchClubList();
  Future<ClubModel> fetchClubByMail(String mail) => clubsApiProvider.fetchClubByMail(mail);
  Future<ClubModel> updateClub(ClubModel club) =>
      clubsApiProvider.updateClub(club);

  final profApiProvider = ProfApiProvider();
  Future<List<ProfModel>> fetchAllProfs() =>
      profApiProvider.fetchProfList();
  Future<ProfModel> fetchProfByMail(String mailEsiee) =>
      profApiProvider.fetchProfByMail(mailEsiee);

  final studentApiProvider = StudentApiProvider();
  Future<List<StudentModel>> fetchAllStudents() =>
      studentApiProvider.fetchStudentList();
  Future<StudentModel> fetchStudent(String mailEsiee) =>
      studentApiProvider.fetchStudent(mailEsiee);



  final gradesApiProvider = GradesApiProvider();
  Future<List<GradesModel>> fetchAllGrades() => gradesApiProvider.fetchGradesList();

  final gradesUnitApiProvider = GradesUnitApiProvider();
  Future<List<GradesUnitModel>> fetchAllGradesUnit(String gradesID) => gradesUnitApiProvider.fetchGradesUnitList(gradesID);

  final fairpayLogApiProvider = FairpayLogApiProvider();
  Future<List<FairpayLogModel>> fetchFairpayLogs() => fairpayLogApiProvider.fetchFairpayLogList();
  Future<List<FairpayLogModel>> fetchLogsByClub(String id) => fairpayLogApiProvider.fetchLogsByClub(id);

}
