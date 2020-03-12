import 'dart:async';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class ClubApiProvider {
  final log = Logger('clubAPI');
  Client client = Client();

  Future<List<ClubModel>> fetchClubList() async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/club/clubs");
    if (response.statusCode == 200) {
      return ClubModel.allClubsFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<ClubModel> fetchClubByMail(String mail) async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/club/club?mail="+Uri.encodeFull(mail));
    log.fine(response.statusCode);
    if (response.statusCode == 200) {
      return ClubModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
