import 'dart:ui';

import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../blocs/events_bloc.dart';
import 'package:intl/intl.dart';

import 'event_creation.dart';
import 'event_info.dart';

class EventList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventListState();
  }
}

class EventListState extends State<EventList> {
  final bloc = EventsBloc();
  final log = Logger('eventList');

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
        backgroundColor: Colors.blue,
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
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child : Text(
                                    getTitle(snapshot.data[index]),
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.0))),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),
                                color: Colors.blueAccent),
                          ),
                          padding: EdgeInsets.only(top: 10.0,left: 15.0, right: 15.0)),
                      getEventCover(snapshot.data[index], context)
                  ]))
            );
        });
  }

  String getTitle(EventModel event){
    String result = event.title;
    if(event.start != null)  result += '  -  '+DateFormat('dd MMM').format(event.start)+'.';
    return result;
  }

  Widget getEventCover(EventModel event, BuildContext context){
    if(event.image == null) {
      event.image = "";
    }
    if(event.end != null && event.end.isAfter(DateTime.now())) {
      return Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Image.network(
          event.image,
          fit: BoxFit.cover,
          width: MediaQuery
              .of(context)
              .size
              .width, height: 150,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        elevation: 5,
        margin: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
      );
    }
    else{
      return Stack(children: <Widget>[
          Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            color: Colors.black,
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstOut),
              image: new NetworkImage(
                event.image,
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0)
        ),
        Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child : Center( child : Text( ("terminé").toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8), fontSize: 30.0))),
            margin: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0)
        ),
      ]);
    }
  }

}



