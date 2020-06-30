import 'dart:async';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class ClubApiProvider {
  final log = Logger('clubAPI');
  Client client = Client();

  Future<List<ClubModel>> fetchClubList() async {
    final response = await client
        .get("http://137.74.197.140:8080/api-1-SNAPSHOT/club/clubs");
    if (response.statusCode == 200) {
      return ClubModel.allClubsFromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<ClubModel> fetchClubByMail(String mail) async {
    final response = await client.get(
        "http://137.74.197.140:8080/api-1-SNAPSHOT/club/club?mail=" +
            Uri.encodeFull(mail));
    log.fine(response.statusCode);
    if (response.statusCode == 200) {
      return ClubModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<ClubModel> updateClub(ClubModel club) async {
    int i = 0;
    String lRoles = "";
    for (RoleModel role in club.roles) {
      if (i != 0) {
        lRoles += ",";
      }
      lRoles += role.idRole.toString();
      i++;
    }

    i = 0;
    String lStudents = "";
    for (StudentModel student in club.students) {
      if (i != 0) {
        lStudents += ",";
      }
      if (student.idStudent.toString() != "null") {
        lStudents += student.idStudent.toString();
        i++;
      }
    }

    String url = Uri.encodeFull(
        "http://137.74.197.140:8080/api-1-SNAPSHOT/club/update?idClubRef=" +
            club.idClubRef.toString() +
            "&idClub=" +
            club.idClub.toString() +
            "&name=" +
            club.name.toString() +
            "&mail=" +
            club.mail.toString() +
            "&price=" +
            club.price.toString() +
            "&contact=" +
            club.contact.toString() +
            "&solde=" +
            club.solde.toString() +
            "&description=" +
            club.description.toString() +
            "&url_photo=" +
            club.urlPhoto.toString() +
            "&url_fb=" +
            club.urlFB.toString() +
            "&roles=" +
            lRoles +
            "&students=" +
            lStudents +
            "&url_network=" +
            club.urlNetwork.toString() +
            "&url_background=" +
            club.urlBackground.toString());
    final response = await client.post(
      url,
    );
    if (response.statusCode == 200) {
      return ClubModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }
}
