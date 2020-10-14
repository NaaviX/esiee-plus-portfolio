import 'dart:async';

import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:meta/meta.dart';

import 'event_api_provider.dart';


class EventRepository {
  final EventApiProvider eventApiProvider;

  EventRepository({@required this.eventApiProvider})
      : assert(eventApiProvider != null);

  Future<List<EventModel>> fetchEvents() async {
    return eventApiProvider.fetchEventList();
  }

  Future<EventModel> deleteEvent(EventModel event) async {
    return eventApiProvider.deleteEvent(event);
  }

  Future<EventModel> saveEvent(EventModel event) async {
    return eventApiProvider.addEvent(event);
  }
}