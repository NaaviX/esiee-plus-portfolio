import 'dart:async';

import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/resources/stock_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/student_api_provider.dart';
import 'package:meta/meta.dart';


class StudentRepository {
  final StudentApiProvider studentApiProvider;

  StudentRepository({@required this.studentApiProvider})
      : assert(studentApiProvider != null);

  Future<List<StudentModel>> fetchStudents() async {
    return studentApiProvider.fetchStudentList();
  }

  Future<StudentModel> fetchStudent(String email) async {
    return studentApiProvider.fetchStudent(email);
  }

  Future<StudentModel> saveStudent(StudentModel student) async {
    return studentApiProvider.updateStudent(student);
  }
}