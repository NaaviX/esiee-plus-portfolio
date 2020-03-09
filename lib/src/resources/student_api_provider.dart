import 'dart:async';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class StudentApiProvider {
  final log = Logger('studentAPI');
  Client client = Client();

  Future<List<StudentModel>> fetchStudentList() async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/student/students");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> students = json.decode(response.body);
      return StudentModel.allStudentsFromJson(students);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load students');
    }
  }

  Future<StudentModel> fetchStudent(String mailEsiee) async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/student/student?mail_esiee="+Uri.encodeFull(mailEsiee));
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      dynamic students = json.decode(response.body);
      return StudentModel.fromJson(students);
    } else {
      // If that call was not successful, return null;
      return null;
    }
  }


}
