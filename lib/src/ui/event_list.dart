import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../blocs/events_bloc.dart';
import 'package:intl/intl.dart';

import 'event_creation.dart';

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
            child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network(
              snapshot.data[index].image,
              fit: BoxFit.fill,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ));
        });
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }

  String getMonth(DateTime date){
    return new DateFormat('MMMM').format(date);
  }

}

//When user click on an event
class EventInfoPage extends StatelessWidget{
  /// TODO : Affichage des infos de l'event
  final EventModel event;
  EventInfoPage({this.event});

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(event.image)
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        )
      )
    );
  }
}

