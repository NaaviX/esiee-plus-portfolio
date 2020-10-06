import 'dart:ui';

import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'event_creation.dart';

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
  final eventBloc = EventsBloc();
  final clubBloc = ClubsBloc();

  String selected;

  @override
  void initState() {
    super.initState();
    eventBloc.fetchAllEvents();
    clubBloc.fetchAllClubs();
    selected = "Mes évents";
  }

  @override
  void dispose() {
    eventBloc.dispose();
    clubBloc.dispose();
    super.dispose();
  }

  final log = Logger('eventList');

  /*Future<bool> isInternetConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }*/

  /*Future<String> getLocalEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('eventsJson');
    return localEvents;
  }*/

  /*Future<String> getLocalClubs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('clubsJson');
    return localEvents;
  }*/

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
    return StreamBuilder(
      stream: eventBloc.allEvents,
      builder: (context, AsyncSnapshot<List<EventModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if(Base.thisClub != null) dropDown(),
            Expanded(
              child: buildList(snapshot.data),
            ),
          ],
        );
      },
    );
  }

  /*Widget builEventListLocal() {
    return FutureBuilder(
        future: getLocalEvents(),
        builder: (BuildContext context, AsyncSnapshot<String> eventsJson) {
          if (eventsJson.hasData) {
            dynamic jsonData = jsonDecode(eventsJson.data);
            List<EventModel> snapshot = EventModel
                .allEventsFromJson(jsonData)
                .reversed
                .toList();
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
          return Center(child: CircularProgressIndicator());
        }
    );
  }*/

  Widget buildList(List<EventModel> events) {
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
        : StreamBuilder(
        stream: clubBloc.allClubs,
        builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            //scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        getCoverModerator(events[index], snapshot.data, context),
                      ]
                  ),
                );
              }
          );
        }
    );
  }

  getCover(EventModel event, BuildContext context) {
    if(widget.moderation == true) {
      if(event.endDate.isAfter(DateTime.now()))
        return EventCard(event, context, moderation: true);
    }
    if (event.publicationDate.isBefore(DateTime.now()) && event.enable == true) {
      if (Base.thisClub != null && selected != "Tous") {
        if (event.idClubRef == Base.thisClub.idClubRef && selected == "Mes évents")
          return EventCard(event, context);
        else return Container();
      }
      else if (Base.thisProf != null){
        if(event.enabledStratif == true) return EventCard(event, context);
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

  getCoverModerator(EventModel event, List<ClubModel> clubs, BuildContext context){
    //ClubModel club = clubs.firstWhere((club) => club.idClubRef == event.idClubRef);
    if(event.endDate.isAfter(DateTime.now()))
      return EventCard(event, context, moderation: true);
    return Container();
  }

  creationButton() {
    if(Base.thisClub != null && widget.moderation!=true)
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreation(this)),
          );
        },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Theme.of(context).primaryColor,
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



