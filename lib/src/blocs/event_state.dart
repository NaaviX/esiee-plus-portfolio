import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:meta/meta.dart';

abstract class EventState  {
  const EventState();

}

class EventsInitial extends EventState {}

class EventsLoadInProgress extends EventState {}

class EventsLoadSuccess extends EventState {
  final List<EventModel> events;

  const EventsLoadSuccess({@required this.events}) : assert(events != null);

}

class EventsLoadFailure extends EventState {}

class EventDeleteFailure extends EventState {}

class EventDeleteInitial extends EventState {}

class EventDeleteInProgress extends EventState {}

class EventDeleteSuccess extends EventState {
  final EventModel event;

  const EventDeleteSuccess({@required this.event}) : assert(event != null);

}





class EventSaveLoadSuccess extends EventState {
  final EventModel event;

  const EventSaveLoadSuccess({@required this.event}) : assert(event != null);

}




class EventSaveLoadFailure extends EventState {}

