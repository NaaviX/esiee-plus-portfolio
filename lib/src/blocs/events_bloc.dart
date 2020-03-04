import 'package:bde_esiee_mobile/src/models/event_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final _repository = Repository();
  final _eventsFetcher = PublishSubject<List<EventModel>>();
  final _title = BehaviorSubject<String>();

  Observable<List<EventModel>> get allEvents => _eventsFetcher.stream;

  fetchAllEvents() async {
    List<EventModel> eventmodel = await _repository.fetchAllEvents();
    eventmodel = sort(eventmodel);
    _eventsFetcher.sink.add(eventmodel);
  }

  addSaveEvent() {
    _repository.addSaveEvent(_title.value);
  }

  dispose() {
    _eventsFetcher.close();
  }

  List<EventModel> sort(List<EventModel> list){
    List<EventModel> oldEvents = List.from(list);
    List<EventModel> newEvents = List.from(list);
    List<EventModel> currentEvents = List.from(list);
    oldEvents.removeWhere((item) => item.endDate == null || item.endDate.isAfter(DateTime.now()));
    newEvents.removeWhere((item) => item.startDate == null || item.startDate.isBefore(DateTime.now()));
    currentEvents.removeWhere((item) => item.endDate == null || item.endDate.isBefore(DateTime.now()) || item.startDate.isAfter(DateTime.now()));
    return currentEvents+newEvents+oldEvents;
  }
}




