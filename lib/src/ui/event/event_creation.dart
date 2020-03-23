import 'dart:io';

import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../App.dart';
import 'event_creation_form.dart';
import 'event_info.dart';

class EventCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventCreationState();
  }
}

class EventCreationState extends State<EventCreation> {

  final log = Logger('eventCreation');
  final bloc = EventsBloc();

  createEventForm  form = new createEventForm();

  @override Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text("Nouvel Evenement")
      ),
      body: form,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send, color: Colors.white,),
          splashColor: Colors.white,
          onPressed: () {
            if (form.formKey.currentState.validate()) {
              EventModel event = EventModel(
                  idEvent: 0,
                  name: form.titre.text,
                  startDate: form.start,
                  endDate: form.end,
                  place: form.place.text,
                  backgroundUrl: verifURL(),
                  description: form.description.text,
                  publicationDate: form.pub,
                  link: form.link.text,
                  facebookLink: form.fblink.text,
                  idClubRef: Base.thisClub.idClubRef,
                  enable: true,
                  price: int.parse(form.price.text)
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventInfoPage(event: event, isValidator: true,)));
            }
          }
      ),
    );
  }

  verifURL() {
    if(form.uploadedFileURL != null) return form.uploadedFileURL;
    else return "null";
  }
}