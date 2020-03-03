//When user click on an event
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/resources/translations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventInfoPage extends StatelessWidget{
  final EventModel event;
  EventInfoPage({this.event});

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(event.name),
        ),
        body: Column(children : [Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(event.backgroundUrl)
              ),
              color: Colors.white,
            )),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                getDate(),
                ListTile(
                  leading: Icon(Icons.check_circle,color: Colors.green, size: 30.0,),
                  title: new Text(Translations.of(context).text("cluborga")),
                ),
                ListTile(
                  leading: Icon(Icons.home,color: Colors.green, size: 30.0,),
                  title: Text(event.place),
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on,color: Colors.green, size: 30.0,),
                  title: new Text(Translations.of(context).text("salelink")),
                ),
                ListTile(
                  leading: Icon(Icons.textsms,color: Colors.green, size: 30.0,),
                  title: new Text(Translations.of(context).text("eventdescri") + event.description.replaceAll(RegExp('<[^>]*>'), ""))
                )
            ],)
            )]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          child: Icon(Icons.calendar_today, color: Colors.white),
          backgroundColor: Colors.blue,
        )
    );
  }

  Widget getDate()
  {
    if( formatDate(event.endDate) == formatDate(event.startDate))
      {
        return ListTile(
          leading: Icon(Icons.calendar_today,color: Colors.green, size: 30.0,),
          title: Text('Le ' + formatDate(event.startDate)),
        );
      }
    else
      {
        return ListTile(
          leading: Icon(Icons.calendar_today,color: Colors.green, size: 30.0,),
          title: Text('Du ' + formatDate(event.startDate)),
          subtitle: Text('Au ' + formatDate(event.endDate)),
        );
      }
  }

  String formatDate(DateTime date)
  {
    return DateFormat('dd MMMM').format(date);
  }


}