import 'dart:async';

import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'club_api_provider.dart';
import 'event_api_provider.dart';

class Repository {
  final eventsApiProvider = EventApiProvider();
  Future<List<EventModel>> fetchAllEvents() =>
      eventsApiProvider.fetchEventList();


  final clubsApiProvider = ClubApiProvider();
  Future<List<ClubModel>> fetchAllClubs() =>
      clubsApiProvider.fetchClubList();
}
