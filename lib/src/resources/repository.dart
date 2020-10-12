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
import 'package:http/http.dart';
import 'Calendar/gradesUnit_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/Calendar/grades_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/prof_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/role_api_provider.dart';
import 'club_api_provider.dart';
import 'event_api_provider.dart';
import 'jwt_api_provider.dart';

class Repository {

  final studentApiProvider = StudentApiProvider(client : Client());
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
  Future<List<CourseModel>> fetchAllCourses(String ids) => coursesApiProvider.fetchCoursesList();

  final freeRoomsApiProvider = FreeRoomsApiProvider();
  Future<List<dynamic>> fetchFreeRooms() => freeRoomsApiProvider.fetchFreeRoomsList();

  final unitApiProvider = UnitApiProvider();
  Future<List<UnitModel>> fetchUnits() => unitApiProvider.fetchUnitsList();

}
