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
    final response = await client.get("https://bde.esiee.fr/clubs.json");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      log.fine(json.decode(response.body)["Clubs du BDE"][0]["title"]);
      List<dynamic> clubs = json.decode(response.body)["Clubs du BDE"];
      clubs.addAll(json.decode(response.body)["Clubs du BDS"]);
      clubs.addAll(json.decode(response.body)["Associations"]);
      return ClubModel.allClubsFromJson(clubs);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
