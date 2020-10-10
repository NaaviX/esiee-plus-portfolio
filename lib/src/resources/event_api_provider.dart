import 'dart:async';
import 'dart:io';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

import '../App.dart';

class EventApiProvider {
  final log = Logger('eventAPI');
  static const baseUrl = 'http://137.74.197.140:8080/api-2-SNAPSHOT';
  final Client client;

  EventApiProvider({
    @required this.client,
  }) : assert(client != null);

  Future<List<EventModel>> fetchEventList() async {
    final response = await client.get("$baseUrl/event/events",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      List<EventModel> events = EventModel.allEventsFromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      // If the call to the server was successful, parse the JSON
      return events;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load events');
    }
  }

  Future<EventModel> addEvent(EventModel event) async {
    final response = await client.post(
        "$baseUrl/event/add",
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
        },
        headers: {
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      return EventModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }


  Future<EventModel> deleteEvent(EventModel event) async {
    final response = await client.delete(
        "$baseUrl/event/"+event.idEvent.toString(),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
    return event;
  }
}
