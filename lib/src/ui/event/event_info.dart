//When user click on an event
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/custom_item_with_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../App.dart';
import 'event_creation.dart';

class EventInfoPage extends StatefulWidget {

  EventModel event;
  bool isValidator;
  bool isModeration;

  EventInfoPage({this.event, this.isValidator, this.isModeration}) {
    if(this.isValidator != null) this.isValidator = this.isValidator;
    else this.isValidator = false;

    if(this.isModeration != null) this.isModeration = this.isModeration;
    else this.isModeration = false;
  }

  @override
  State<StatefulWidget> createState() {
    return EventInfoState();
  }
}

class EventInfoState extends State<EventInfoPage> {

  final bloc = ClubsBloc();
  final Eventbloc = EventsBloc();

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
          title: _title(),
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
                    _header(snapshot),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15,0,15,0),
                      padding:  EdgeInsets.fromLTRB(0,0,0,15),
                      child: Text(widget.event.description, style: TextStyle(fontSize: 18,),textAlign: TextAlign.justify,),
                    ),
                    getDate(),
                    Padding(
                      padding:  EdgeInsets.only(left: 5),
                      child: Column(
                          children: <Widget>[

                          ]
                      ),
                    ),

                    list(Icons.place,widget.event.place),
                    list(Icons.euro_symbol,widget.event.price.toString() + ' €'),
                    list(Icons.payment, widget.event.link),
                    list(FontAwesomeIcons.facebookSquare, widget.event.facebookLink),
                    _validationMod(),
                  ]
              );
            }
            else
              return Container();
          }
      ),
      floatingActionButton: _manage(widget.event.idClubRef),
    );
  }

  getDate()
  {
    if( formatDate(widget.event.endDate) == formatDate(widget.event.startDate))
    {
      if( widget.event.endDate == widget.event.startDate)
        return list(
            Icons.access_time,
            'Le ' + formatDate(widget.event.startDate) + DateFormat(' à HH:mm','fr_FR').format(widget.event.startDate)
        );
      else
        return list(
            Icons.access_time,
            'Le ' + formatDate(widget.event.startDate) + ' de' + DateFormat(' HH:mm','fr_FR').format(widget.event.startDate) + DateFormat(' à HH:mm','fr_FR').format(widget.event.endDate)
        );
    }
    else {
      return list(
          Icons.access_time,
          'Du ' + formatDate(widget.event.startDate) + DateFormat(' - HH:mm','fr_FR').format(widget.event.startDate) + ' \nAu ' + formatDate(widget.event.endDate) + DateFormat(" - HH:mm",'fr_FR').format(widget.event.startDate));
    }
  }

  Container list(IconData icon, String text)
  {
    bool hyperlink = false;
    if(text == "0 €") text = "Gratuit";
    if(icon == Icons.payment || icon == FontAwesomeIcons.facebookSquare) hyperlink = true;
    if(text != null && text !="") {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
        child: CustomItemWithIcon(icon, text, hyperlink : hyperlink,),);
    }
    else {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
      );
    }
  }

  String formatDate(DateTime date)
  {
    return DateFormat('EEE ','fr_FR').format(date) + formatDay(date) + DateFormat(' MMMM','fr_FR').format(date);
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

  _header(AsyncSnapshot<ClubModel> snapshot) {
    return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(formatMonth(widget.event.startDate), style: TextStyle(fontSize: 15, color: Colors.red,)),
                Text(formatDay(widget.event.startDate), style: TextStyle(fontSize: 35,)),
              ],
            ),
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : <Widget>[
                      AutoSizeText(
                        widget.event.name.toUpperCase(),
                        style: TextStyle(color: Colors.black, fontSize: 25.0,),
                        maxLines: 1,
                        textAlign: TextAlign.left,
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
          ),
        ]
    );
  }

  _title() {
    if(widget.isValidator) return Text("Preview");
    else return Text("");
  }

  _manage(int clubRef) {
    if(widget.isModeration) {
      return null;
    }
    else if(widget.isValidator) {
      return FloatingActionButton(
          child: Icon(Icons.check, color: Colors.white,),
          splashColor: Colors.white,
          onPressed: () {
            Eventbloc.addSaveEvent(widget.event);
            Base.selectedIndex = 2;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
          }
      );
    }
    else if(Base.thisClub != null && Base.thisClub.idClubRef == clubRef) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventCreation(event: widget.event)),);
            },
            child: Icon(Icons.edit, color: Colors.white,),
            label: "Modifier",
          ),
          SpeedDialChild(
            onTap: () {
              Eventbloc.deleteEvent(widget.event);
              Base.selectedIndex = 2;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => App()));
            },
            backgroundColor: Colors.red,
            child: Icon(Icons.delete, color: Colors.white,),
            label: "Supprimer",
          ),
        ],
      );
    }
    else return Container();
  }

  bool _isEnabled = false;

  _validationMod() {
    return SwitchListTile(
      //CODE DE MAXIME
      //affiche Validé (o=) si l'évent n'est pas validé par le BDE
      //affiche Validé (=o) sinon
      //bouton pour supprimer l'évent avec un alert dialogue pour valider qu'on veut supprimer
      title:const Text('Autorisé ?'),
      value: _isEnabled,

      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.red,
    );
  }
}