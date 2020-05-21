import 'dart:async';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class ProfApiProvider {
  final log = Logger('profAPI');
  Client client = Client();

  Future<List<ProfModel>> fetchProfList() async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/prof/profs");
    if (response.statusCode == 200) {
      return ProfModel.allProfsFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load user');
    }
  }
  Future<ProfModel> fetchProfByMail(String mail) async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/prof/prof?mail_esiee="+Uri.encodeFull(mail));
    if (response.statusCode == 200) {
      return ProfModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  Future<ProfModel> addProf(ProfModel prof) async {
    final response = await client.post(
        "http://137.74.197.140:8080/api-1-SNAPSHOT/prof/add",
        body: {
          'idProf': prof.idProf.toString(),
          'firstname': prof.firstname,
          'lastname': prof.lastname,
          'mailEsiee': prof.mailEsiee,
          'phone': prof.phone,
          'office': prof.office,
          'urlPhoto': prof.urlPhoto,
          'unitsId': [],
          'classesId': [],
        });
    if (response.statusCode == 200) {
      return ProfModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }
}
