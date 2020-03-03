import 'dart:async';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class EventApiProvider {
  final log = Logger('eventAPI');
  Client client = Client();

  Future<List<EventModel>> fetchEventList() async {
    EventModel eventModel = null;
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/event/events");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return EventModel.allEventsFromJson(
          json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
