import 'dart:convert';

import 'package:logging/logging.dart';

class EventModel {
  final log = Logger('eventModel');

  int idEvent;                   //idEvent
  String name;             //name
  DateTime startDate;           //startDate
  DateTime endDate;             //endDate
  String place;             //place
  String backgroundUrl;             //backgroundUrl
  String description;           //description   //
  String publicationDate;   //publicationDate
  String link;              //

  EventModel({
    this.idEvent,
    this.name,
    this.startDate,
    this.endDate,
    this.place,
    this.backgroundUrl,
    this.description,
    this.publicationDate,
    this.link,
  });

  factory EventModel.fromJson(Map<String, dynamic> parsedJson) {
    EventModel e = new EventModel();

    if (parsedJson != null) {
      e.idEvent = parsedJson["idEvent"];
      e.name = parsedJson["name"];
      e.description = parsedJson["description"];

      e.publicationDate = parsedJson["publicationDate"];

      e.startDate = DateTime.parse(parsedJson["startDate"]);
      e.endDate = DateTime.parse(parsedJson["endDate"]);
      e.place = parsedJson["place"];

      e.backgroundUrl = parsedJson["backgroundUrl"];
      if(e.backgroundUrl == null) {
        e.backgroundUrl = "";
      }
      e.link = parsedJson["sellLink"];
      if(e.name == null) {
        e.name = "";
      }
      if(e.link == null) {
        e.link = "";
      }

      if(e.description == null) {
        e.description = "";
      }
      if(e.place == null) {
        e.place = "";
      }
    }
    return e;
  }

  static List<EventModel> allEventsFromJson(List<dynamic> jsonData) {
    return new List<EventModel>.from(
        jsonData.map((x) => EventModel.fromJson(x)));
  }
}
