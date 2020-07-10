import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventModel {
  final log = Logger('eventModel');

  int idEvent;                   //idEvent
  String name;             //name
  DateTime startDate;           //startDate
  DateTime endDate;             //endDate
  String place;             //place
  String backgroundUrl;             //backgroundUrl
  String description;           //description   //
  DateTime publicationDate;   //publicationDate
  String link;              //
  String facebookLink;
  int idClubRef;
  bool enable;
  double price;
  bool enabledStratif;
  int points;

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
    this.facebookLink,
    this.idClubRef,
    this.enable,
    this.price,
    this.enabledStratif,
    this.points,
  });

  factory EventModel.fromJson(Map<String, dynamic> parsedJson) {
    EventModel e = new EventModel();

    if (parsedJson != null) {
      e.idEvent = parsedJson["idEvent"];
      e.name = parsedJson["name"];
      e.description = parsedJson["description"];

      try {
        e.publicationDate = DateTime.parse(parsedJson["publicationDate"]);

        e.startDate = DateTime.parse(parsedJson["startDate"]);
        e.endDate = DateTime.parse(parsedJson["endDate"]);
      } catch(e) {

      }
      e.place = parsedJson["place"];

      e.idClubRef = parsedJson["idClubRef"];

      e.price = parsedJson["price"];

      e.backgroundUrl = parsedJson["backgroundUrl"];
      e.enable = parsedJson["enabled"];
      e.enabledStratif = parsedJson["enabledStratif"];
      e.points = parsedJson["points"];
      e.price = parsedJson["price"];
      e.link = parsedJson["sellLink"];
      e.facebookLink = parsedJson["facebookLink"];
      e.idClubRef = parsedJson["idClubRef"];

      if(e.backgroundUrl == null || e.backgroundUrl == "null") {
        e.backgroundUrl = "https://bde.esiee.fr/bundles/applicationbde/img/couverture.png";
      }
      if(e.name == null) {
        e.name = "";
      }
      if(e.link == null) {
        e.link = "";
      }
      if(e.facebookLink == null) {
        e.facebookLink = "";
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

  static void saveJsonLocal(List<dynamic> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("eventsJson", json.encode(value));
  }

  static List<EventModel> allEventsFromJson(List<dynamic> jsonData) {
    saveJsonLocal(jsonData);
    return new List<EventModel>.from(
        jsonData.map((x) => EventModel.fromJson(x)));
  }
}
