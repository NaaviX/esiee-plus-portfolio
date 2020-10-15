import 'dart:ui';
import 'package:bde_esiee_mobile/src/blocs/event_event.dart';
import 'package:bde_esiee_mobile/src/blocs/event_state.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../../App.dart';
import 'event_creation.dart';

// ignore: must_be_immutable
class EventList extends StatefulWidget {
  bool moderation;
  final EventsBloc eventsBloc;

  EventList({this.moderation, @required this.eventsBloc}) {
    if(this.moderation != null) this.moderation = this.moderation;
    else this.moderation = false;
    assert(eventsBloc != null);
  }

  @override
  State<StatefulWidget> createState() {
    return EventListState();
  }
}

class EventListState extends State<EventList> {

  String selected;

  @override
  void initState() {
    widget.eventsBloc.add(EventsRequested());
    super.initState();
    selected = "Mes évents";
  }

  final log = Logger('eventList');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: builEventList(),/*FutureBuilder(
          future: isInternetConnected(),
          builder: (BuildContext context, AsyncSnapshot<bool> connected) {
            return connected.hasData && connected.data
                ? builEventList()
                : builEventListLocal();
          }),*/
      floatingActionButton: creationButton(),
    );
  }

  Widget builEventList() {

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if(Base.thisClub != null) dropDown(),
                Expanded(
                  child: buildList(),
                ),
              ],
            );
  }

  Widget buildList() {
    return BlocBuilder<EventsBloc, EventState>(builder: (context, state) {
      if (state is EventsInitial) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is EventsLoadInProgress) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is EventsLoadSuccess) {
        final events = state.events;
        Base.allEvents = events.toList();

        return !widget.moderation
            ? ListView.builder(
          //scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCover(events[index], context),
                    ]
                ),
              );
            }
        )
            : ListView.builder(
          //scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCoverModerator(events[index], Base.allClubs, context),
                    ]
                ),
              );
            }
        );
      }
      if (state is EventsLoadFailure) {
        return Text(
          'Impossible de récupérer les evenements!',
          style: TextStyle(color: Colors.red),
        );
      }
      return Container();
    });

  }

  getCover(EventModel event, BuildContext context) {
    if(widget.moderation == true) {
      if(event.endDate.isAfter(DateTime.now()))
        return EventCard(event, context, moderation: true, eventsBloc: widget.eventsBloc,);
    }
    if (event.publicationDate.isBefore(DateTime.now()) && event.enable == true) {
      if (Base.thisClub != null && selected != "Tous") {

        if (event.idClubRef == Base.thisClub.idClubRef && selected == "Mes évents")
          return EventCard(event, context, eventsBloc: widget.eventsBloc);
        else return Container();
      }
      else if (Base.thisProf != null){
        if(event.enabledStratif == true) return EventCard(event, context, eventsBloc: widget.eventsBloc);
        else return Container();
      }
      else
        return EventCard(event, context, eventsBloc: widget.eventsBloc);
    }
    else if (Base.thisClub != null && selected == "En attente") {
      if (event.idClubRef == Base.thisClub.idClubRef) return EventCard(event, context, eventsBloc: widget.eventsBloc);
      else return Container();
    }
    else return Container();
  }

  getCoverModerator(EventModel event, List<ClubModel> clubs, BuildContext context){
    //ClubModel club = clubs.firstWhere((club) => club.idClubRef == event.idClubRef);
    if(event.endDate.isAfter(DateTime.now()))
      return EventCard(event, context, moderation: true, eventsBloc: widget.eventsBloc);
    return Container();
  }

  creationButton() {
    if(Base.thisClub != null && widget.moderation!=true)
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreation(this, eventsBloc: widget.eventsBloc)),
          );
        },
        child: Icon(Icons.add,),
      );
  }

  List<String> list = ["Tous", "Mes évents", "En attente"];

  dropDown() {
    if(widget.moderation!=true) {
      return Container(
          width: (500),
          margin: EdgeInsets.only(left: 10, top: 10, right: 10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: Column(),
                value: selected,
                onChanged: (String newValue) {
                  setState(() {
                    selected = newValue;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(
                        role,
                        style: TextStyle(
                            color: role == selected ? Colors.black : Colors
                                .black54,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold)
                    ),
                  );
                }).toList(),
              ))
      );
    }
    else return Container();
  }

}



