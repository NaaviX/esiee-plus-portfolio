import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../App.dart';
import 'event_creation_form.dart';
import 'event_info.dart';
import 'event_list.dart';
import 'package:meta/meta.dart';

// ignore: must_be_immutable
class EventCreation extends StatefulWidget {
  final EventsBloc eventsBloc;
  CreateEventForm form;
  EventModel event;

  EventCreation({this.event, @required this.eventsBloc}) {
    if (event != null)
      this.form = CreateEventForm(
        event: event,
      );
    else
      form = CreateEventForm();
    assert(eventsBloc != null);
  }

  @override
  State<StatefulWidget> createState() {
    return EventCreationState();
  }
}

class EventCreationState extends State<EventCreation> {
  final log = Logger('eventCreation');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Nouvel Événement")),
      body: widget.form,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward,),
          onPressed: () {
            if (widget.form.formKey.currentState.validate()) {
              EventModel event = EventModel(
                idEvent: idEvent(),
                name: widget.form.titre.text,
                startDate: widget.form.start,
                endDate: widget.form.end,
                place: widget.form.place.text,
                backgroundUrl: verifURL(),
                description: widget.form.description.text,
                publicationDate: widget.form.pub,
                link: widget.form.link.text,
                facebookLink: widget.form.fblink.text,
                idClubRef: Base.thisClub.idClubRef,
                enable: widget.event != null ? widget.event.enable : false,
                price: double.parse(widget.form.price.text),
                enabledStratif: widget.form.isForStratif,
                points: 0,
                  topEvent: false,
              );
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider<EventsBloc>.value(
                      value: widget.eventsBloc,
                      child: EventInfoPage(
                        event,
                        Base.thisClub,
                        isValidator: true,
                        eventsBloc: widget.eventsBloc,
                      )
                  )
              ));
            }
          }),
    );
  }

  verifURL() {
    if (widget.form.uploadedFileURL != null)
      return widget.form.uploadedFileURL;
    else
      return "null";
  }

  idEvent() {
    if (widget.form.event != null)
      return widget.form.event.idEvent;
    else
      return 0;
  }
}
