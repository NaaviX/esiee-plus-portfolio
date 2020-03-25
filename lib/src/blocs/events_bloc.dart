import 'package:bde_esiee_mobile/src/models/event_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final _repository = Repository();
  final _eventsFetcher = PublishSubject<List<EventModel>>();
  final _eventFetcher = PublishSubject<EventModel>();

  Observable<List<EventModel>> get allEvents => _eventsFetcher.stream;
  Observable<EventModel> get event => _eventFetcher.stream;

  fetchAllEvents() async {
    List<EventModel> eventmodel = await _repository.fetchAllEvents();
    eventmodel = sort(eventmodel);
    _eventsFetcher.sink.add(eventmodel);
  }

  deleteEvent(EventModel event) async {
    await _repository.deleteEvent(event);

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

    List<EventModel> disableEvent = List.from(list);
    disableEvent.removeWhere((item) => item.enable==true);

    List<EventModel> unpublishedEvent = List.from(list);
    unpublishedEvent.removeWhere((item) => item.enable==false || item.publicationDate.isBefore(DateTime.now()));

    list.removeWhere((item) => item.enable==false || item.publicationDate.isAfter(DateTime.now()));
    List<EventModel> oldEvents = List.from(list);
    List<EventModel> newEvents = List.from(list);
    List<EventModel> currentEvents = List.from(list);
    oldEvents.removeWhere((item) => item.endDate == null || item.endDate.isAfter(DateTime.now()));
    newEvents.removeWhere((item) => item.startDate == null || item.startDate.isBefore(DateTime.now()));
    currentEvents.removeWhere((item) => item.endDate == null || item.endDate.isBefore(DateTime.now()) || item.startDate.isAfter(DateTime.now()));

    disableEvent.sort((item1, item2) => item1.startDate.compareTo(item2.startDate));
    unpublishedEvent.sort((item1, item2) => item1.publicationDate.compareTo(item2.publicationDate));
    currentEvents.sort((item1, item2) => item1.endDate.compareTo(item2.endDate));
    newEvents.sort((item1, item2) => item1.startDate.compareTo(item2.startDate));
    oldEvents.sort((item1, item2) => item2.startDate.compareTo(item1.startDate));
    return disableEvent+unpublishedEvent+currentEvents+newEvents+oldEvents;
  }
}




