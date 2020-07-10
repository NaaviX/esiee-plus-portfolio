import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../App.dart';
import 'event_creation_form.dart';
import 'event_info.dart';

class EventCreation extends StatefulWidget {
  createEventForm form;

  EventCreation({EventModel event}){
    if(event != null) this.form = createEventForm(event: event,);
    else form = createEventForm();
  }

  @override
  State<StatefulWidget> createState() {
    return EventCreationState();
  }
}

class EventCreationState extends State<EventCreation> {

  final log = Logger('eventCreation');
  final bloc = EventsBloc();

  @override Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text("Nouvel Evenement")
      ),
      body: widget.form,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send, color: Colors.white,),
          splashColor: Colors.white,
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
                  enable: false,
                  price: double.parse(widget.form.price.text),
                  enabledStratif: widget.form.isForStratif,
                  points: 0,
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventInfoPage(event, Base.thisClub , isValidator: true,)));
            }
          }
      ),
    );
  }

  verifURL() {
    if(widget.form.uploadedFileURL != null) return widget.form.uploadedFileURL;
    else return "null";
  }

  idEvent() {
    if(widget.form.event != null) return widget.form.event.idEvent;
    else return 0;
  }
}