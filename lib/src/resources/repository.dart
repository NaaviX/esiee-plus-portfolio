import 'dart:async';

import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'event_api_provider.dart';

class Repository {
  final eventsApiProvider = EventApiProvider();

  Future<List<EventModel>> fetchAllEvents() =>
      eventsApiProvider.fetchEventList();
}
