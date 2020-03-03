import 'dart:convert';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'package:logging/logging.dart';

class EventModel {
  final log = Logger('eventModel');

  int idEvent;                   //idEvent
  String name;             //name
  DateTime startDate;           //startDate
  DateTime endDate;             //endDate
  String place;             //place
  String backgroundUrl;             //backgroundUrl
  String description;           //description
  String slug;              //
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
    this.slug,
    this.publicationDate,
    this.link,
  });

  factory EventModel.fromJson(Map<String, dynamic> parsedJson) {
    EventModel e = new EventModel();

    if (parsedJson != null) {
      e.idEvent = parsedJson["idEvent"];
      e.name = parsedJson["name"];
      e.description = parse(parsedJson["description"]).outerHtml;

      e.slug = parsedJson["slug"];
      e.publicationDate = parsedJson["created_at"];
    }

    if (parsedJson["event"] != null) {
      e.startDate = DateTime.parse(parsedJson["event"]["start"]);
      e.endDate = DateTime.parse(parsedJson["event"]["end"]);
      e.place = parsedJson["event"]["place"];
    }

    if (parsedJson["photo"] != null) {
      e.backgroundUrl = parsedJson["photo"]["url"];
    }

    return e;
  }

  static List<EventModel> allEventsFromJson(List<dynamic> jsonData) {
    return new List<EventModel>.from(
        jsonData.map((x) => EventModel.fromJson(x)));
  }
}
