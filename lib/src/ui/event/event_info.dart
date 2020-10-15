//When user click on an event
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/blocs/event_event.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_info.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/EventCard.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/custom_item_with_icon.dart';
import 'package:bde_esiee_mobile/src/ui/event/event_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../App.dart';
import 'event_creation.dart';
import 'package:meta/meta.dart';

// ignore: must_be_immutable
class EventInfoPage extends StatefulWidget {

  @required EventModel event;
  @required ClubModel club;
  EventCardState parentCard;
  bool isValidator;
  bool isModeration;
  final EventsBloc eventsBloc;


  EventInfoPage(this.event, this.club, {this.parentCard, this.isValidator, this.isModeration, @required this.eventsBloc}) {
    if(this.isValidator != null) this.isValidator = this.isValidator;
    else this.isValidator = false;

    if(this.isModeration != null) this.isModeration = this.isModeration;
    else this.isModeration = false;
    assert(eventsBloc != null);
  }

  @override
  State<StatefulWidget> createState() {
    return EventInfoState();
  }
}

class EventInfoState extends State<EventInfoPage> {

  bool _isEnabled = false;
  bool _isForStratif = false;
  bool _isTopEvent = false;

  bool _isFav = false;

  Future<String> getSavedEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('savedEventsJson');
    return localEvents;
  }

  void favEvent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('savedEventsJson');
    List<dynamic> savedEvents = localEvents != null ? json.decode(localEvents) : [];
    savedEvents.add( widget.event );
    String savedEventsJson = json.encode(savedEvents);
    prefs.setString("savedEventsJson", savedEventsJson);
  }

  void unfavEvent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('savedEventsJson');
    List<dynamic> savedEvents = localEvents != null ? json.decode(localEvents) : [];
    savedEvents.removeWhere((event) => event["idEvent"] == widget.event.idEvent);
    prefs.setString("savedEventsJson", json.encode(savedEvents));
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title(),
        ),
        body: ListView(
            children: <Widget>[
              Stack(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: _filter(widget.event),
                                image : NetworkImage(widget.event.backgroundUrl)
                            )
                        )
                    ),
                    _isEnded(context, widget.event),
                  ]
              ),
              _header(),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Divider(
                  color: Provider.of<ThemeNotifier>(context, listen: false).isDarkMode ? Colors.white : Colors.black,
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
              SizedBox(height: 10,),
              _suppressionMod(),
              SizedBox(height: 50,),
            ]
        ),
        floatingActionButton: _floatingActionButton()
    );
  }

  _floatingActionButton() {
    if (!widget.isModeration)
      return FutureBuilder(
          future: getSavedEvents(),
          builder: (BuildContext context, AsyncSnapshot<String> eventsJson) {
              if (Base.thisClub != null)
                return _manage(widget.event.idClubRef);
              if (Base.thisUser != null && !widget.isModeration){
                dynamic jsonData = eventsJson.hasData ? jsonDecode(eventsJson.data) : [];
                List<EventModel> snapshot = jsonData != null ? EventModel.allEventsFromJson(jsonData) : [];
                _isFav = snapshot.where((event) => event.idEvent == widget.event.idEvent).toList().length > 0;
                return FloatingActionButton(
                  child: Icon( _isFav ?  FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, size: 25,
                      color: (_isFav ? Colors.redAccent : Colors.blueGrey.withOpacity(0.5))),
                  splashColor: Colors.white,
                  backgroundColor: Theme.of(context).backgroundColor,
                  elevation: 0,
                  highlightElevation: 0,
                  onPressed: () {
                    _isFav ? unfavEvent() : favEvent();
                    setState(() {
                      _isFav = !_isFav;
                      widget.parentCard.setState(() {

                      });
                    });
                  },
                );
              }
          /*if (Base.thisClub != null)
            return _manage(widget.event.idClubRef);
          if (Base.thisUser != null && !widget.isModeration)
            return FloatingActionButton(
              child: Icon(Icons.event_available, size: 40,
                  color: (Colors.blueGrey.withOpacity(0.5))),
              splashColor: Colors.white,
              backgroundColor: Background,
              onPressed: () {
                _isFav ? unfavEvent() : favEvent();
                setState(() {
                  _isFav = !_isFav;
                });
              },
            );*/

          return Container();
        }
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
          'Du ' + formatDate(widget.event.startDate) + DateFormat(' - HH:mm','fr_FR').format(widget.event.startDate) + ' \nAu ' + formatDate(widget.event.endDate) + DateFormat(" - HH:mm",'fr_FR').format(widget.event.endDate));
    }
  }

  Container list(IconData icon, String text)
  {
    String hyperlink;
    if(text == "0.0 €") text = "Gratuit";
    if(icon == Icons.payment || icon == FontAwesomeIcons.facebookSquare) hyperlink = text;
    if(text != null && text !="") {
      icon == Icons.payment ? text = "lien de vente" : text = text;
      icon == FontAwesomeIcons.facebookSquare ? text = "lien facebook de l'événement" : text = text;
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
        child: CustomItemWithIcon(icon, text, hyperlink : hyperlink,),);
    }
    else {
      return Container(
        //padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
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

  _header() {
    return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(formatMonth(widget.event.startDate), style: TextStyle(fontSize: 15, color: Colors.redAccent, fontWeight: FontWeight.w500)),
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
                        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                      Row(children: <Widget>[
                        Text("Organisé par "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ClubInfoPage(club : widget.club),),
                            );
                          },
                          child: Text(
                              widget.club.name,
                              style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                        ),
                        SizedBox(width: 5,),
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.club.urlPhoto),
                          backgroundColor: Colors.white,
                          radius: 10,
                        ),
                      ]
                      ),
                    ]
                )
            ),
          ),
          /*Container(
              padding: EdgeInsets.only(right: 20, top: 10),
              child: GestureDetector(
                  child: Icon(Icons.event_available, size: 40, color: (_isFav ? PrimaryColor : Colors.blueGrey.withOpacity(0.5))),
                  onTap: () {
                    setState(() {
                      _isFav = !_isFav;
                    });
                  }
              )
          )*/
        ]
    );
  }

  _title() {
    if(widget.isValidator) return Text("Preview");
    else return Text(widget.event.name);
  }

  _manage(int clubRef) {
    if(widget.isValidator) {
      return FloatingActionButton(
          child: Icon(Icons.check,),
          splashColor: Colors.white,
          onPressed: () {
            widget.eventsBloc.add(EventToBeSaved(event: widget.event));
            Base.selectedIndex = 1;
            if(Base.thisUser != null)
              Base.selectedIndex = 2;
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => App()), (Route<dynamic> route) => false);
          }
      );
    }
    else if(Base.thisClub != null && Base.thisClub.idClubRef == clubRef) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        children: [
          SpeedDialChild(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventCreation(this, event : widget.event, eventsBloc: widget.eventsBloc,)),);
              },
              child: Icon(Icons.edit,),
              label: "Modifier",
              labelStyle: TextStyle(color: Colors.black)
          ),
          SpeedDialChild(
              onTap: () {
                _neverSatisfied();
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.delete, color: Colors.white,),
              label: "Supprimer",
              labelStyle: TextStyle(color: Colors.black)
          ),
        ],
      );
    }
    return Container();
  }

  _validationMod() {
    _isEnabled = widget.event.enable;
    _isForStratif = widget.event.enabledStratif;
    _isTopEvent = widget.event.topEvent;
    if(widget.isModeration)
    {
      return Column(
        children: <Widget>[
          SwitchListTile(
            title:const Text('Autorisé'),
            value: _isEnabled,
            onChanged: (bool value)
            {
              setState( ()
              {
                _isEnabled = value;
                widget.event.enable = _isEnabled;
                widget.eventsBloc.add(EventToBeSaved(event: widget.event));
              });
            },
            activeColor : Colors.green,
            inactiveThumbColor : Colors.red,
          ),
          SwitchListTile(
            title:const Text('Top Event '),
            value: _isTopEvent,
            onChanged: (bool value)
            {
              setState( ()
              {
                _isTopEvent = value;
              });
              widget.event.topEvent = _isTopEvent;
              widget.eventsBloc.add(EventToBeSaved(event: widget.event));

            },
            activeColor : Colors.green,
            inactiveThumbColor : Colors.red,
          ),
          SwitchListTile(
            title:const Text('Administratifs admis'),
            value: _isForStratif,
            onChanged: (bool value)
            {
              setState( ()
              {
                _isForStratif = value;
              });
              widget.event.enabledStratif = _isForStratif;
              widget.eventsBloc.add(EventToBeSaved(event: widget.event));
            },
            activeColor : Colors.green,
            inactiveThumbColor : Colors.red,
          )
        ],
      );
    }
    else {
      return Container();
    }
  }

  _suppressionMod(){
    if(widget.isModeration)
    {
      return Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.red,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.white,
            onPressed: () {
              _neverSatisfied();
            },
          ),
        ),
      );
    }
    else
    {
      return Container();
    }
  }

  _isEnded(context, EventModel event) {
    if (!(event.endDate != null && event.endDate.isAfter(DateTime.now())) || event.enable == false || event.publicationDate.isAfter(DateTime.now()))
      return Container(
          height: 150,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Center(
              child: AutoSizeText(
                (_text(event)).toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 30.0),
                maxLines: 1,
              )
          ),
          margin: EdgeInsets.only(
              bottom: 0.0, left: 15.0, right: 15.0)
      );
    else return Container();
  }

  _filter(EventModel event) {
    if (!(event.endDate != null && event.endDate.isAfter(DateTime.now())) || event.enable == false || event.publicationDate.isAfter(DateTime.now())) return new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstOut);
    else return null;
  }

  _text(EventModel event) {
    if (!(event.endDate != null && event.endDate.isAfter(DateTime.now()))) return "terminé";
    else if(event.enable == false) return "en attente d'approbation";
    else if(event.publicationDate.isAfter(DateTime.now())) return "pas encore publié";
    else return "";
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SUPPRESSION'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Êtes-vous sûr de vouloir supprimer l\’Event ?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Oui'),
              onPressed: () {
                widget.eventsBloc.add(EventDeleteRequested(event: widget.event));
                widget.eventsBloc.add(EventsRequested());
                if(Base.thisClub != null && !widget.isModeration) {
                  Base.selectedIndex = 1;
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => App()), (Route<dynamic> route) => false);
                }
                else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => EventManager(eventsBloc: widget.eventsBloc,)), (Route<dynamic> route) => false);
                }
              },
            ),
            FlatButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}