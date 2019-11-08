import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../blocs/events_bloc.dart';


class EventList extends StatelessWidget {
  final log = Logger('eventList');

  @override
  Widget build(BuildContext context){
    bloc.fetchAllEvents();
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
          // Add your onPressed code here!
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
          return Card(
            child: ListTile(

              title: Text("${snapshot.data[index].title}"),
              subtitle: createEvent(snapshot.data[index]),
            ),
          );
        });
  }

  Text createEvent(EventModel e) {
    if(e.place != null) {
      return Text("${e.place}\n${e.start} - ${e.end}\n${e.end}");
    }
  }

}