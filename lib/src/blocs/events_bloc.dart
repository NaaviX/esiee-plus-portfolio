import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/resources/event_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';

import 'event_event.dart';
import 'event_state.dart';

class EventsBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventsBloc({@required this.eventRepository})
      : assert(eventRepository != null),
        super(EventsInitial());

  @override
  Stream<EventState> mapEventToState(EventEvent event) async* {
    if (event is EventDeleteRequested) {
      yield EventDeleteInProgress();
      try {
        final EventModel eventToDelete = await eventRepository.deleteEvent(event.event);
        yield EventDeleteSuccess(event: eventToDelete);
      } catch (_) {
        yield EventDeleteFailure();
      }
    }

    if (event is EventsRequested) {
      yield EventsLoadInProgress();
      try {
        final List<EventModel> events = await eventRepository.fetchEvents();

        yield EventsLoadSuccess(events: sort(events));
      } catch (_) {
        yield EventsLoadFailure();
      }
    }

    else if (event is EventToBeSaved) {
      try {
        await eventRepository.saveEvent(event.event);
      } catch (_) {
        yield EventSaveLoadFailure();
      }
    }
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




