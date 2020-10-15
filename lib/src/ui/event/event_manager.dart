import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/ui/event/event_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class EventManager extends StatelessWidget {
  final EventsBloc eventsBloc;

  EventManager({Key key, @required this.eventsBloc})
      : assert(eventsBloc != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestion des évènements"),
        ),
        body: BlocProvider<EventsBloc>.value(
            value: eventsBloc,
            child: EventList(moderation: true,eventsBloc: eventsBloc,))
    );
  }


}