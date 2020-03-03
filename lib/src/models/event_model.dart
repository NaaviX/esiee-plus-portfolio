import 'dart:convert';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'package:logging/logging.dart';

class EventModel {
  final log = Logger('eventModel');

  int id;
  String title;
  DateTime start;
  DateTime end;
  String place;
  String image;
  String content;
  String slug;
  String publicationDate;
  String link;

  EventModel({
    this.id,
    this.title,
    this.start,
    this.end,
    this.place,
    this.image,
    this.content,
    this.slug,
    this.publicationDate,
    this.link,
  });

  factory EventModel.fromJson(Map<String, dynamic> parsedJson) {
    EventModel e = new EventModel();

    if (parsedJson != null) {
      e.id = parsedJson["id"];
      e.title = parsedJson["title"];
      e.content = parse(parsedJson["content"]).outerHtml;

      e.slug = parsedJson["slug"];
      e.publicationDate = parsedJson["created_at"];
    }

    if (parsedJson["event"] != null) {
      e.start = DateTime.parse(parsedJson["event"]["start"]);
      e.end = DateTime.parse(parsedJson["event"]["end"]);
      e.place = parsedJson["event"]["place"];
    }

    if (parsedJson["photo"] != null) {
      e.image = parsedJson["photo"]["url"];
    }

    return e;
  }

  static List<EventModel> allEventsFromJson(List<dynamic> jsonData) {
    return new List<EventModel>.from(
        jsonData.map((x) => EventModel.fromJson(x)));
  }
}
