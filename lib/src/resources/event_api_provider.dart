import 'dart:async';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

  Future<EventModel> addEvent(EventModel event) async {
    final response = await client.post(
        "http://137.74.197.140:8080/api-1-SNAPSHOT/event/add",
        body: {
          'id_event': event.idEvent.toString(),
          'enabled': event.enable.toString(),
          'publication_date': DateFormat("yyyy-MM-dd HH:mm:ss","en_US").format(event.publicationDate),
          'start_date': DateFormat("yyyy-MM-dd HH:mm:ss","en_US").format(event.startDate),
          'end_date': DateFormat("yyyy-MM-dd HH:mm:ss","en_US").format(event.endDate),
          'name': event.name,
          'description': event.description,
          'place': event.place,
          'price': event.price.toString(),
          'sell_link': event.link,
          'facebook_link': event.facebookLink,
          'id_club_ref': event.idClubRef.toString(),
          'background_url': event.backgroundUrl,
          "points": 0.toString(),
          'enabled_stratif' : event.enabledStratif.toString(),
        });
    if (response.statusCode == 200) {
      return EventModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }


  void deleteEvent(EventModel event) async {
    final response = await client.delete(
        "http://137.74.197.140:8080/api-1-SNAPSHOT/event/"+event.idEvent.toString());
    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }
}
