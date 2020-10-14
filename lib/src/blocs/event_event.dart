import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:meta/meta.dart';
abstract class EventEvent {
  const EventEvent();
}

class EventDeleteRequested extends EventEvent {

  final EventModel event;
  const EventDeleteRequested({@required this.event}) : assert(event != null);

}

class EventsRequested extends EventEvent {

  const EventsRequested();

}
class EventToBeSaved extends EventEvent {
  final EventModel event;
  const EventToBeSaved({@required this.event}) : assert(event != null);

}