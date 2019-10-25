import 'package:bde_esiee_mobile/src/models/event_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final _repository = Repository();
  final _eventsFetcher = PublishSubject<List<EventModel>>();

  Observable<List<EventModel>> get allEvents => _eventsFetcher.stream;

  fetchAllEvents() async {
    List<EventModel> eventmodel = await _repository.fetchAllEvents();
    _eventsFetcher.sink.add(eventmodel);
  }

  dispose() {
    _eventsFetcher.close();
  }
}

final bloc = EventsBloc();
