import 'dart:async';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
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
      List<dynamic> students = json.decode(utf8.decode(response.bodyBytes));
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
      dynamic students = json.decode(utf8.decode(response.bodyBytes));
      return StudentModel.fromJson(students);
    } else {
      // If that call was not successful, return null;
      return null;
    }
  }

  Future<StudentModel> fetchStudentById(String idStudent) async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/student/student/"+Uri.encodeFull(idStudent));
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
        "http://137.74.197.140:8080/api-1-SNAPSHOT/student/update?id_student=" +
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
    );
    if (response.statusCode == 200) {
      return StudentModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }




}
