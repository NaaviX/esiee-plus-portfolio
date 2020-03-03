import 'package:bde_esiee_mobile/src/models/event_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final _repository = Repository();
  final _eventsFetcher = PublishSubject<List<EventModel>>();

  Observable<List<EventModel>> get allEvents => _eventsFetcher.stream;

  fetchAllEvents() async {
    List<EventModel> eventmodel = await _repository.fetchAllEvents();
    eventmodel = sort(eventmodel);
    _eventsFetcher.sink.add(eventmodel);
  }

  dispose() {
    _eventsFetcher.close();
  }

  List<EventModel> sort(List<EventModel> list){
    List<EventModel> oldEvents = List.from(list);
    List<EventModel> newEvents = List.from(list);
    oldEvents.removeWhere((item) => item.endDate == null || item.endDate.isAfter(DateTime.now()));
    newEvents.removeWhere((item) => item.endDate == null || item.endDate.isBefore(DateTime.now()));
    return newEvents+oldEvents;
  }
}




