import 'dart:convert';

import 'package:logging/logging.dart';

class ClubModel {
  final log = Logger('clubModel');



  int id;
  String category;
  String title;
  String abstract;
  String logoUrl;
  String email;
  int points;

  ClubModel({
    this.id,
    this.category,
    this.title,
    this.abstract,
    this.logoUrl,
    this.email,
    this.points
  });

  factory ClubModel.fromJson(Map<String, dynamic> parsedJson) {
    ClubModel e = new ClubModel();

    if (parsedJson != null) {
      e.id = parsedJson["id"];
      if(parsedJson["category_id"] == 2) {
        e.category = "Clubs du BDE";
      } else if(parsedJson["category_id"] == 3) {
        e.category = "Clubs du BDS";
      } else if(parsedJson["category_id"] == 4) {
        e.category = "Associations";
      }

      e.title = parsedJson["title"];
      e.abstract = parsedJson["abstract"];
      e.logoUrl = parsedJson["logo_url"];
      e.email = parsedJson["email"];
      e.points = parsedJson["points"];
    }

    return e;
  }

  static List<ClubModel> allClubsFromJson(List<dynamic> jsonData) {
    return new List<ClubModel>.from(
        jsonData.map((x) => ClubModel.fromJson(x)));
  }



}