import 'dart:async';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class EventApiProvider {
  final log = Logger('eventAPI');
  Client client = Client();
  final _url = 'http://137.74.197.140:8080/api-1-SNAPSHOT/v2/api-docs';

  Future<List<EventModel>> fetchEventList() async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/event/events");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return EventModel.allEventsFromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future addEvent(title) async {
    final response = await client.post("$_url/add", body: {'name': title});
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to add data');
    }
  }


  Future<EventModel> updateEvent(EventModel event) async {
    final response = await client.post(
        "http://137.74.197.140:8080/api-1-SNAPSHOT/event/update",
        body: {
          'id_event': event.idEvent,
          'enabled': event.enable,
          'publication_date': event.publicationDate,
          'start_date': event.startDate,
          'end_date': event.endDate,
          'name': event.name,
          'description': event.description,
          'place': event.place,
          'price': event.price,
          'sell_link': event.link,
          'facebook_link': event.facebookLink,
          'id_club_ref': event.idClubRef,
          'background_url': event.backgroundUrl,
        });
    if (response.statusCode == 200) {
      return EventModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }
}
