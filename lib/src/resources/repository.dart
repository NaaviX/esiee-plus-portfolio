import 'dart:async';

import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:bde_esiee_mobile/src/models/gradesUnit_model.dart';
import 'package:bde_esiee_mobile/src/models/grades_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/resources/Calendar/courses_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/Fairpay/fairpay_log_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/freeRooms_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/stock_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/student_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/unit_api_provider.dart';
import 'Calendar/gradesUnit_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/Calendar/grades_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/prof_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/role_api_provider.dart';
import 'club_api_provider.dart';
import 'event_api_provider.dart';

class Repository {

  final rolesApiProvider = RoleApiProvider();
  Future<List<RoleModel>> fetchAllRoles() => rolesApiProvider.fetchRoleList();

  final eventsApiProvider = EventApiProvider();
  Future<List<EventModel>> fetchAllEvents() => eventsApiProvider.fetchEventList();
  Future<EventModel> addSaveEvent(EventModel event) => eventsApiProvider.addEvent(event);
  void deleteEvent(EventModel event) => eventsApiProvider.deleteEvent(event);

  final clubsApiProvider = ClubApiProvider();
  Future<List<ClubModel>> fetchAllClubs() => clubsApiProvider.fetchClubList();
  Future<ClubModel> fetchClubByMail(String mail) => clubsApiProvider.fetchClubByMail(mail);
  Future<ClubModel> updateClub(ClubModel club) => clubsApiProvider.updateClub(club);

  final profApiProvider = ProfApiProvider();
  Future<List<ProfModel>> fetchAllProfs() =>
      profApiProvider.fetchProfList();
  Future<ProfModel> fetchProfByMail(String mailEsiee) =>
      profApiProvider.fetchProfByMail(mailEsiee);
  Future<ProfModel> addSaveProf(ProfModel prof) => profApiProvider.addProf(prof);

  final studentApiProvider = StudentApiProvider();
  Future<List<StudentModel>> fetchAllStudents() =>
      studentApiProvider.fetchStudentList();
  Future<StudentModel> fetchStudent(String mailEsiee) =>
      studentApiProvider.fetchStudent(mailEsiee);
  Future<StudentModel> fetchStudentById(String idStudent) =>
      studentApiProvider.fetchStudentById(idStudent);
  Future<StudentModel> updateStudent(StudentModel student) =>
      studentApiProvider.updateStudent(student);

  final gradesApiProvider = GradesApiProvider();
  Future<List<GradesModel>> fetchAllGrades() => gradesApiProvider.fetchGradesList();

  final gradesUnitApiProvider = GradesUnitApiProvider();
  Future<List<GradesUnitModel>> fetchAllGradesUnit(String gradesID) => gradesUnitApiProvider.fetchGradesUnitList(gradesID);

  final coursesApiProvider = CoursesApiProvider();
  Future<List<CourseModel>> fetchAllCourses(String ids) => coursesApiProvider.fetchCoursesList(ids);

  final fairpayLogApiProvider = FairpayLogApiProvider();
  Future<List<FairpayLogModel>> fetchFairpayLogs() => fairpayLogApiProvider.fetchFairpayLogList();
  Future<List<FairpayLogModel>> fetchLogsByClub(String id) => fairpayLogApiProvider.fetchLogsByClub(id);
  Future<FairpayLogModel> addLog(FairpayLogModel log) => fairpayLogApiProvider.addLog(log);

  final freeRoomsApiProvider = FreeRoomsApiProvider();
  Future<List<dynamic>> fetchFreeRooms() => freeRoomsApiProvider.fetchFreeRoomsList();

  final unitApiProvider = UnitApiProvider();
  Future<List<UnitModel>> fetchUnits() => unitApiProvider.fetchUnitsList();

  final stockApiProvider = StockApiProvider();
  Future<List<StockModel>> fetchStocks() => stockApiProvider.fetchStocksList();
  Future<StockModel> addSaveStock(StockModel stock) => stockApiProvider.addStock(stock);

}
