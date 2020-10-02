import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/ui/event/event_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeComponents extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeComponentsState();
  }
}

class HomeComponentsState extends State<HomeComponents> {

  final eventBloc = EventsBloc();
  final clubBloc = ClubsBloc();
  final rate = 10;

  @override
  void initState() {
    eventBloc.fetchAllEvents();
    clubBloc.fetchAllClubs();
    super.initState();
  }

  @override
  void dispose() {
    eventBloc.dispose();
    clubBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
        //child: Container(
            //color: Colors.orange,
            child : Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                /*infoComponents("Bienvenue","Bienvenue sur l'appli Esiee plus, une appli conçue pour tout les esieens. On éspère qu'elle te sera utile."),
                SizedBox(height: 5),*/
                //alertComponents(Icons.warning,"Attention !","Bienvenue sur l'appli Esiee plus, une appli conçue pour tout les esieens. On éspère qu'elle vous sera utile."),
                dealComponent("https://upload.wikimedia.org/wikipedia/fr/b/b7/Logo_EVS.png", "https://www.facebook.com/watch/?v=239657580749804", "Code + Permis pour 650€ avec le code ESIEE", "Si tu n'as pas ton permis c'est surement l'occasion de le passer. "
                    "Ton BDE chérie t'as négocié les meilleurs offres, n'attend plus. "
                    "Tu es alternant ? Béneficie d'une aide supplémentaire de 500€."),
                SizedBox(height: 5),
                eventComponent(2),
                SizedBox(height: 5),
              ],
            )
        //)
    );
  }

  infoComponents(String title, String text){
    //double height = MediaQuery.of(context).size.height-153-270-62;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue.withOpacity(0.6), Colors.blue.withOpacity(0.8)])),
      height: 120,
      child:Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 5),
                Text(title, textAlign:TextAlign.justify, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white))
              ],
            ),
            SizedBox(height: 7),
            Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),)
          ],
        ),
      ),
    );
  }

  alertComponents(IconData icon, String title, String text){
    //double height = MediaQuery.of(context).size.height-153-270-62;
    return Container(
      color: Colors.red.withOpacity(0.6),
      //height: 120,
      child:Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 5),
                Text(title, textAlign:TextAlign.justify, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white))
              ],
            ),
            SizedBox(height: 7),
            Text(text, style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }

  _filter(EventModel event) {
    if (!(event.endDate != null && event.endDate.isAfter(DateTime.now())) || event.enable == false || event.publicationDate.isAfter(DateTime.now())) return new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstOut);
    else return null;
  }
  pushEventInfo(EventModel event, ClubModel club) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => EventInfoPage(event, club));
    Navigator.push(
      context,
      route,
    );
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

  _eventInfo(EventModel event) {
    return Container(
        child : Row(
            children: <Widget>[
              Container(
                color: Colors.black.withOpacity(0.6),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(formatMonth(event.startDate), style: TextStyle(fontSize: 15, color: Colors.white,)),
                    Text(formatDay(event.startDate), style: TextStyle(fontSize: 35, color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children : <Widget>[
                          /*AutoSizeText(
                            event.name.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 25.0,),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),*/
                          Row(children: <Widget>[
                            //Text("Organisé par "),
                            /*GestureDetector(
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
                        ),*/
                            SizedBox(width: 5,),
                            /*CircleAvatar(
                          backgroundImage: NetworkImage(widget.club.urlPhoto),
                          backgroundColor: Colors.white,
                          radius: 10,
                        ),*/
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
        ));
  }

  eventComponent(int idEvent){
    //double height = MediaQuery.of(context).size.height-153-270-62;
    return StreamBuilder(
        stream: eventBloc.allEvents,
        builder: (context, AsyncSnapshot<List<EventModel>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 120,
              color: Colors.grey.withOpacity(0.2),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          EventModel event = snapshot.data.firstWhere((event) => event.idEvent == idEvent);
          return StreamBuilder(
              stream: clubBloc.allClubs,
              builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                      child: _eventInfo(event),
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(event.backgroundUrl)
                          )
                      )
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                ClubModel club = snapshot.data.firstWhere((club) => club.idClubRef == event.idEvent);
                return GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                            child: _eventInfo(event),
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(event.backgroundUrl)
                                )
                            )
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventInfoPage(event, club)),
                    )
                );}
          );
        }
    );
  }

  dealComponent(String urlLogo, String link, String title, String description){
    //double height = MediaQuery.of(context).size.height-153-270-62;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                stops: [0.1, 0.4, 1],
                end: Alignment.bottomLeft,
                colors: [Colors.lightBlue, Colors.blue, Colors.blueAccent])),
        //height: 120,
        child:Container(
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(title, textAlign:TextAlign.justify, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                      SizedBox(height: 5),
                      Text(description, textAlign:TextAlign.justify, style: TextStyle(color: Colors.white)),
                    ],
                  )),
              SizedBox(width: 10),
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  radius: 35,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(urlLogo),
                    backgroundColor: Theme.of(context).backgroundColor,
                    radius:35,
                  ),
                ),
              ) ,
            ],
          ),
        ),
      ),
      onTap: () async {
        if (await canLaunch(link)) {
          await launch(
            link,
          );
        }
      },
    );

  }

}