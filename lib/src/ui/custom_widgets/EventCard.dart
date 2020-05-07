import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {

  @required BuildContext context;
  @required EventModel event;

  EventCard(this.event, this.context);

  @override
  State<StatefulWidget> createState() {
    return EventCardState();
  }
}

class EventCardState extends State<EventCard> {

  final club = ClubsBloc();

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
        // ignore: missing_return
        builder: (context, AsyncSnapshot<ClubModel> snapshot) {
          return Padding(
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
                                    width: MediaQuery.of(context).size.width - 120,
                                    child: Text(
                                      event.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 19.0),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  clubName(snapshot),
                                ],
                              ),
                              clubLogo(snapshot),
                            ]
                        ),
                      ),
                    ]),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
              ),
              padding: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0, bottom: 5)
          );
        }
    );


  }

  clubName(AsyncSnapshot<ClubModel> snapshot) {
    if(snapshot.hasData){
      return Text(snapshot.data.name);
    }
    else return Container();
  }

  clubLogo(AsyncSnapshot<ClubModel> snapshot) {
    if(snapshot.hasData){
      return Positioned(
        top: 0,
        right: 0,
        child: CircleAvatar(
          backgroundImage: NetworkImage(snapshot.data
              .urlPhoto),
          backgroundColor: Colors.white,
          radius: 29,
        ),
      );
    }
    else return Container();
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