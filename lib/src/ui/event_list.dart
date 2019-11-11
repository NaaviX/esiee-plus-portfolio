import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../blocs/events_bloc.dart';
import 'package:intl/intl.dart';

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
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data[index].image),
            ),
            title: Text(snapshot.data[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventInfoPage(event : snapshot.data[index])),
              );
            },
          );
        });
  }

  Text createEvent(EventModel e) {
    if(e.place != null) {
      return Text(
          "${formatDate(e.start)}\n"
          "${e.place}");
    }
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }



}

//When user click on an event
class EventInfoPage extends StatelessWidget{

  final EventModel event;
  EventInfoPage({this.event});

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Center(
        child: Image.network(
        event.image,
        )
      ),
    );
  }
}

//When user (Club) click on add button
class EventCreationPage extends StatelessWidget{

  final EventModel event = new EventModel();

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Center(
          child: Image.network(
            event.image,
          )
      ),
    );
  }
}

