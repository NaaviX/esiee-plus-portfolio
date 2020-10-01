import 'dart:async';
import 'dart:io';
import 'package:bde_esiee_mobile/src/models/class_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

import '../App.dart';

class ProfApiProvider {
  final log = Logger('profAPI');
  Client client = Client();

  Future<List<ProfModel>> fetchProfList() async {
    final response = await client.get("http://137.74.197.140:8080/api-2-SNAPSHOT/prof/profs",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      return ProfModel.allProfsFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load user');
    }
  }
  Future<ProfModel> fetchProfByMail(String mail) async {
    final response = await client.get("http://137.74.197.140:8080/api-2-SNAPSHOT/prof/prof?mail_esiee="+Uri.encodeFull(mail),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      return ProfModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  Future<ProfModel> addProf(ProfModel prof) async {

    String url = Uri.encodeFull(
        "http://137.74.197.140:8080/api-2-SNAPSHOT/prof/add?id_prof=" +
            prof.idProf.toString() +
            "&firstname=" +
            prof.firstname +
            "&lastname=" +
            prof.lastname +
            "&mail_esiee=" +
            prof.mailEsiee +
            "&phone=" +
            prof.phone +
            "&office=" +
            prof.office +
            "&url_photo=" +
            prof.urlPhoto);

    if(prof.units != null && prof.units.length != 0) {
      for (UnitModel unit in prof.units) {
        url += Uri.encodeFull("&unitsId="+unit.idUnit.toString());
      }
    } else {
      url += Uri.encodeFull("&unitsId=");
    }
    if(prof.classes != null && prof.classes.length != 0) {
      for (ClassModel classe in prof.classes) {
        url += Uri.encodeFull("&classesId="+classe.idClass.toString());
      }
    }else {
      url += Uri.encodeFull("&classesId=");
    }
    final response = await client.post(
      url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        }
    );
    if (response.statusCode == 200) {
      return ProfModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }
}
