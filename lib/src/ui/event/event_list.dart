import 'dart:ui';

import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../../blocs/events_bloc.dart';
import 'package:intl/intl.dart';

import 'event_creation.dart';
import 'event_info.dart';

class EventList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventListState();
  }
}

class EventListState extends State<EventList>  /*with AutomaticKeepAliveClientMixin*/ {
  @override
  bool get wantKeepAlive => true;
  final bloc = EventsBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchAllEvents();
  }

  @override
  void dispose() {
    bloc.dispose();
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
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventCreation()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
        )
    );
  }

  Widget buildList(AsyncSnapshot<List<EventModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventInfoPage(event : snapshot.data[index])),
              );
            },
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        child: getEventCover(snapshot.data[index], context),
                        padding: EdgeInsets.only(top: 10.0,left: 15.0, right: 15.0)),
                  ]
              ),
            ),
          );
        });
  }

  String getTitle(EventModel event){
    String result = event.name;
    if (event.startDate != null)
      result += '  -  ' + DateFormat('dd MMM').format(event.startDate) + '.';
    return result;
  }

  Widget getEventCover(EventModel event, BuildContext context){
    if(event.endDate != null && event.endDate.isAfter(DateTime.now())) {
      return Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).primaryColor,
        child: Column(
            children: <Widget>[
              Container(
                height: 40,
                child:  Center(
                  child: Text(getTitle(event), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.0),textAlign: TextAlign.center,),
                ),
              ),
              Image.network(
                event.backgroundUrl,
                fit: BoxFit.cover,
                width: MediaQuery
                    .of(context)
                    .size
                    .width, height: 150,
              ),
            ]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
      );
    }
    else{
      return Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Theme.of(context).primaryColor,
        child: Column(
            children: <Widget>[
              Container(
                height: 40,
                child:  Center(
                  child: Text(getTitle(event), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.0),textAlign: TextAlign.center,),
                ),
              ),
              Stack(children: <Widget>[
                Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstOut),
                        image: new NetworkImage(
                          event.backgroundUrl,
                        ),
                      ),
                    ),
                ),
                Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child : Center( child : Text( ("terminé").toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8), fontSize: 30.0))),
                    margin: EdgeInsets.only(bottom: 0.0, left: 15.0, right: 15.0)
                ),
              ]),
            ]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
      );
    }
  }

}



