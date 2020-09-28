import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/ui/event/event_info.dart';
import 'package:bde_esiee_mobile/src/ui/event/event_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventCard extends StatefulWidget {

  @required BuildContext context;
  @required EventModel event;
  bool moderation;

  EventCard(this.event, this.context, {this.moderation}) {
    this.moderation = this.moderation == null ? false : this.moderation;
  }

  @override
  State<StatefulWidget> createState() {
    return EventCardState();
  }
}

class EventCardState extends State<EventCard> {

  final club = ClubsBloc();

  bool _isFav = false;

  Future<String> getSavedEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('savedEventsJson');
    return localEvents;
  }

  @override
  void initState() {
    super.initState();
    club.fetchClubById(widget.event.idClubRef);
  }

  @override
  void dispose() {
    club.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EventModel event = widget.event;
    return StreamBuilder(
        stream: club.thisClub,
        builder: (context, AsyncSnapshot<ClubModel> snapshot) {
          return GestureDetector(
              onTap: () {
                snapshot.hasData ? pushEventInfo(event, snapshot.data) : null;
              },
              child: Container(
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  //color: Theme.of(context).primaryColor,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                            children: <Widget>[
                              Container(
                                height: 150,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: new BoxDecoration(
                                  color: Colors.black,
                                  image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    colorFilter: _filter(event),
                                    image: new NetworkImage(
                                      event.backgroundUrl,
                                    ),
                                  ),
                                ),
                              ),
                              _isEnded(context, event),
                            ]),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          padding: EdgeInsets.all(15.0),
                          //height: 40,
                          child: Stack(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      getDate(event),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13.0),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 3),
                                    Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width - 120,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: event.name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 19.0),
                                              ),
                                              WidgetSpan(
                                                alignment: PlaceholderAlignment
                                                    .top,
                                                child: _favCard(),
                                              ),
                                              TextSpan(
                                                text: snapshot.hasData ? "\n" + snapshot.data.name : "",
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  //fontSize: 15.0
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                    SizedBox(height: 3),

                                  ],
                                ),
                                snapshot.hasData ? clubLogo(snapshot) : Container(height: 29, width: 29,),
                              ]
                          ),
                        ),
                      ]),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                ),
                padding: EdgeInsets.only(
                    top: 5.0, left: 15.0, right: 15.0, bottom: 5),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
              )
          );
        }
    );
  }

  Widget _favCard() {
    return FutureBuilder(
        future: getSavedEvents(),
        builder: (BuildContext context, AsyncSnapshot<String> eventsJson) {
          dynamic jsonData = eventsJson.hasData ? jsonDecode(eventsJson.data) : [];
          List<EventModel> snapshot = jsonData != null ? EventModel.allEventsFromJson(jsonData) : [];
          _isFav = snapshot.where((event) => event.idEvent == widget.event.idEvent).toList().length > 0;
          return _isFav ? Container(
            child: Icon(FontAwesomeIcons.solidHeart, size: 15, color: Colors.red),
            margin: EdgeInsets.only(left: 5),
          ) :
          Container(
            child: Icon(null, size: 15, color: Colors.red),
            margin: EdgeInsets.only(left: 5),
          );
        }
    );
  }

  pushEventInfo(EventModel event, ClubModel club) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => EventInfoPage(event, club, parentCard: this));
    if(widget.moderation)
      route = MaterialPageRoute(builder: (context) => EventInfoPage(event, club, isModeration: true));
    Navigator.push(
      context,
      route,
    );
  }

  clubName(AsyncSnapshot<ClubModel> snapshot) {
    return Text("\n" + snapshot.data.name);
  }

  clubLogo(AsyncSnapshot<ClubModel> snapshot) {
    return Positioned(
      top: 0,
      right: 0,
      child: CircleAvatar(
        backgroundImage: NetworkImage(snapshot.data.urlPhoto),
        backgroundColor: Theme.of(context).backgroundColor,
        radius: 29,
      ),
    );
  }

  getDate(EventModel event)
  {
    String date;
    if(formatDate(event.endDate) == formatDate(event.startDate))
    {
      date = formatDate(event.startDate) + ' à partir de' + DateFormat(' HH:mm','fr_FR').format(event.startDate);
      //else date = formatDate(event.startDate) + ' de' + DateFormat(' HH:mm','fr_FR').format(event.startDate) + DateFormat(' à HH:mm','fr_FR').format(event.endDate);
    }
    else date = formatDate(event.startDate) + '  -  ' + formatDate(event.endDate);

    return date.toUpperCase();
  }

  String formatDate(DateTime date)
  {
    return DateFormat('EEE ','fr_FR').format(date) + DateFormat('d','fr_FR').format(date) + DateFormat(' MMM','fr_FR').format(date);
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
    if (!(event.endDate != null && event.endDate.isAfter(DateTime.now())) || event.enable == false || event.publicationDate.isAfter(DateTime.now())) return new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstOut);
    else return null;
  }

  _text(EventModel event) {
    if (!(event.endDate != null && event.endDate.isAfter(DateTime.now()))) return "terminé";
    else if(event.enable == false) return "en attente d'approbation";
    else if(event.publicationDate.isAfter(DateTime.now())) return "pas encore publié";
    else return "";
  }
}