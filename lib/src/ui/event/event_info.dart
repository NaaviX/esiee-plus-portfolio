//When user click on an event
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../custom_widgets/Hyperlink';

class EventInfoPage extends StatefulWidget {

  EventModel event;
  EventInfoPage({this.event});

  @override
  State<StatefulWidget> createState() {
    return EventInfoState();

  }
}

class EventInfoState extends State<EventInfoPage> {

  final bloc = ClubsBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchClubById(widget.event.idClubRef);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: StreamBuilder(
          stream: bloc.thisClub,
          builder: (context, AsyncSnapshot<ClubModel> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.event.backgroundUrl)
                          ),
                          color: Colors.white,
                        )
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(formatMonth(widget.event.startDate), style: TextStyle(fontSize: 15, color: Colors.red,)),
                                  Text(formatDay(widget.event.startDate), style: TextStyle(fontSize: 35,)),
                                ],
                              ),),
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                child: Wrap(
                                    direction: Axis.vertical,
                                    alignment: WrapAlignment.start,
                                    children : <Widget>[
                                      Text(
                                        widget.event.name.toUpperCase(),
                                        style: TextStyle(color: Colors.black, fontSize: 25.0,),
                                      ),
                                      Row(children: <Widget>[
                                        Text("Organisé par "),
                                        Text(
                                            snapshot.data.name,
                                            style: TextStyle(fontWeight: FontWeight.bold)
                                        )
                                      ]
                                      ),

                                    ]
                                )
                            ),
                          ]
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5,0,15,0),
                      padding:  EdgeInsets.fromLTRB(0,0,0,15),
                      child: list(null,widget.event.description),
                    ),
                    getDate(),
                    list(Icons.place,widget.event.place),
                    list(Icons.euro_symbol,widget.event.price.toString() + ' €'),
                    list(Icons.payment, widget.event.link),
                    list(FontAwesomeIcons.facebookSquare, widget.event.facebookLink),
                  ]
              );
            }
            else
              return Container();
          }
      ),
    );
  }

  getDate()
  {
    if( formatDate(widget.event.endDate) == formatDate(widget.event.startDate))
    {
      return list(
          Icons.access_time,
          'Le ' + formatDate(widget.event.startDate)
      );
    }
    else {
      return list(
          Icons.access_time,
          'Du ' + formatDate(widget.event.startDate) + ' \nAu ' + formatDate(widget.event.endDate));
    }
  }

  Container list(IconData icon, String text)
  {
    if(text == "0 €") text = "Gratuit";
    if(text != null && text !="") {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
        child: Wrap(
            spacing: 10,
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: <Widget>[
              if(icon != null) Icon(icon, size: 20.0, color: Colors.blue),
              if(icon == Icons.payment || icon == FontAwesomeIcons.facebookSquare)
                Hyperlink(text,text),
              if(icon != Icons.payment && icon != FontAwesomeIcons.facebookSquare)
                Text(text, style: TextStyle(fontSize: 18,),
                  textAlign: TextAlign.justify,),
            ]),
      );
    }
    else {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
      );
    }
  }

  String formatDate(DateTime date)
  {
    return DateFormat('EEE','fr_FR').format(date) + ' ' + formatDay(date) + ' ' + formatMonth(date) + DateFormat(' à HH:mm','fr_FR').format(date);
  }

  String formatMonth(DateTime date)
  {
    String d =  DateFormat('MMM','fr_FR').format(date);
    return d[0].toUpperCase() + d.substring(1);
  }

  String formatDay(DateTime date)
  {
    return  DateFormat('d','fr_FR').format(date);
  }
}