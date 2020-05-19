import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class FreeRoomsApiProvider {
  final log = Logger('freeRoomsAPI');
  Client client = Client();

  Future<List<dynamic>> fetchFreeRoomsList() async {
    final response = await client.get("https://ade.wallforfry.fr/api/rooms/undefined");
    if (response.statusCode == 200) {
      return List<dynamic>.from(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
