import 'dart:ui';

import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'event_creation.dart';
import 'event_info.dart';

class EventList extends StatefulWidget {
  bool moderation;

  EventList({this.moderation}) {
    if(this.moderation != null) this.moderation = this.moderation;
    else this.moderation = false;
  }

  @override
  State<StatefulWidget> createState() {
    return EventListState();
  }
}

class EventListState extends State<EventList>  /*with AutomaticKeepAliveClientMixin*/ {
  @override
  bool get wantKeepAlive => true;
  final bloc = EventsBloc();
  final clubsBloc = ClubsBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchAllEvents();
    clubsBloc.fetchClub(user.email);
  }

  @override
  void dispose() {
    bloc.dispose();
    clubsBloc.dispose();
    super.dispose();
  }

  final log = Logger('eventList');

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: StreamBuilder(
        stream: bloc.allEvents,
        builder: (context, AsyncSnapshot<List<EventModel>> snapshot) {
          if (snapshot.hasData) {
            return getList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: creationButton(),
    );
  }

  Widget buildList(AsyncSnapshot<List<EventModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              eventInfo(snapshot.data[index]);
            },
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getCover(snapshot.data[index], context),
                  ]
              ),
            ),
          );
        }
    );
  }

  eventInfo(EventModel event) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => EventInfoPage(event : event));
    if(widget.moderation == true) route = MaterialPageRoute(builder: (context) => EventInfoPage(event : event, isModeration: true,));
    Navigator.push(
      context,
      route,
    );
  }

  getCover(EventModel event, BuildContext context) {
    if(widget.moderation == true) {
      if(event.endDate.isAfter(DateTime.now())) return EventCard(event, context);
      else return Container();
    }
    else if (event.publicationDate.isBefore(DateTime.now()) && event.enable == true) {
      if (Base.thisClub != null && selected != "Tous") {
        if (event.idClubRef == Base.thisClub.idClubRef && selected == "Mes évents") return EventCard(event, context);
        else return Container();
      }
      else
        return EventCard(event, context);
    }
    else if (Base.thisClub != null && selected == "En attente") {
      if (event.idClubRef == Base.thisClub.idClubRef) return EventCard(event, context);
      else return Container();
    }
    else return Container();
  }

  creationButton() {
    if(Base.thisClub != null && widget.moderation!=true)
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreation()),
          );
        },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Theme.of(context).primaryColor,
      );
  }

  String selected = "Mes évents";
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

  getList(AsyncSnapshot<List<EventModel>> snapshot) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        if(Base.thisClub != null) dropDown(),
        Expanded(
          child: buildList(snapshot),
        ),
      ],
    );
  }

}



