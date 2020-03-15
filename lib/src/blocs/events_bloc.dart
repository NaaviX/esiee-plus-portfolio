import 'package:bde_esiee_mobile/src/models/event_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final _repository = Repository();
  final _eventsFetcher = PublishSubject<List<EventModel>>();
  final _eventFetcher = PublishSubject<EventModel>();
  final _title = BehaviorSubject<String>();

  Observable<List<EventModel>> get allEvents => _eventsFetcher.stream;
  Observable<EventModel> get event => _eventFetcher.stream;

  fetchAllEvents() async {
    List<EventModel> eventmodel = await _repository.fetchAllEvents();
    eventmodel = sort(eventmodel);
    _eventsFetcher.sink.add(eventmodel);
  }

  updateEvent(EventModel event) async {
    EventModel eventmodel = await _repository.updateEvent(event);
  }

  addSaveEvent(EventModel event) async {
    EventModel eventmodel = await _repository.addSaveEvent(event);
  }

  dispose() {
    _eventsFetcher.close();
    _eventFetcher.close();
  }

  List<EventModel> sort(List<EventModel> events){
    List<EventModel> list = events;
    list.removeWhere((item) => !item.enable && item.publicationDate.isBefore(DateTime.now()));
    List<EventModel> oldEvents = List.from(list);
    List<EventModel> newEvents = List.from(list);
    List<EventModel> currentEvents = List.from(list);
    oldEvents.removeWhere((item) => item.endDate == null || item.endDate.isAfter(DateTime.now()));
    newEvents.removeWhere((item) => item.startDate == null || item.startDate.isBefore(DateTime.now()));
    currentEvents.removeWhere((item) => item.endDate == null || item.endDate.isBefore(DateTime.now()) || item.startDate.isAfter(DateTime.now()));
    return currentEvents+newEvents+oldEvents;
  }
}




