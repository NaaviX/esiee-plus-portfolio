//When user click on an event
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';

class EventInfoPage extends StatelessWidget{
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
              color: Colors.white,
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          child: Icon(Icons.calendar_today, color: Colors.white),
          backgroundColor: Colors.blue,
        )
    );
  }
}