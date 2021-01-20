import 'dart:async';
import 'dart:io';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

import '../App.dart';

class StudentApiProvider {
  final log = Logger('studentAPI');
  static const baseUrl = 'http://193.70.84.159:8080/api-1-SNAPSHOT';
  final Client client;

  StudentApiProvider({
    @required this.client,
  }) : assert(client != null);

  Future<List<StudentModel>> fetchStudentList() async {
    final response = await client.get("$baseUrl/student/students",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> students = json.decode(utf8.decode(response.bodyBytes));
      return StudentModel.allStudentsFromJson(students);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load students');
    }
  }

  Future<StudentModel> fetchStudent(String mailEsiee) async {
    final response = await client.get("$baseUrl/student/student?mail_esiee="+Uri.encodeFull(mailEsiee),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      dynamic students = json.decode(utf8.decode(response.bodyBytes));
      return StudentModel.fromJson(students);
    } else {
      // If that call was not successful, return null;
      return null;
    }
  }

  Future<StudentModel> fetchStudentById(String idStudent) async {
    final response = await client.get("$baseUrl/student/student/"+Uri.encodeFull(idStudent),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      dynamic student = json.decode(utf8.decode(response.bodyBytes));
      return StudentModel.fromJson(student);
    } else {
      // If that call was not successful, return null;
      return null;
    }
  }

  Future<StudentModel> updateStudent(StudentModel student) async {
    int i = 0;
    String lRoles = "";
    for (RoleModel role in student.roles) {
      if (i != 0) {
        lRoles += ",";
      }
      lRoles += role.idRole.toString();
      i++;
    }

    String url = Uri.encodeFull(
        "$baseUrl/student/update?id_student=" +
            student.idStudent.toString() +
            "&mail_esiee=" +
            student.mailEsiee.toString() +
            "&firstname=" +
            student.firstname.toString() +
            "&lastname=" +
            student.lastname.toString() +
            "&promo=" +
            student.promo.toString() +
            "&phone=" +
            student.phone.toString() +
            "&is_contributor=" +
            student.isContributor.toString() +
            "&url_photo=" +
            student.urlPhoto.toString() +
            "&classes=" +
            "&clubs=" +
            "&roles=" +
            lRoles);
    log.fine(url);
    final response = await client.post(
      url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        }
    );
    if (response.statusCode == 200) {
      return StudentModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }




}
