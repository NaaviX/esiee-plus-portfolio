//When user click on a club
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/resources/event_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/event_repository.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/EventCard.dart';
import 'package:bde_esiee_mobile/src/ui/messenger/messenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../App.dart';

class ClubInfoPage extends StatefulWidget{

  final ClubModel club;
  ClubInfoPage({this.club});

  @override
  State<StatefulWidget> createState() {
    return ClubInfoPageState();
  }
}

class ClubInfoPageState extends State<ClubInfoPage> {

  int nbrEvent = 0;

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.club.name),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.club.urlBackground)
                  ),
                  color: Colors.transparent,
                ),
              ),
              Positioned(
                  child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(top: 220),
                      child: NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
                          return false;
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(height: 200,),
                              _description(context),
                              Container(
                                margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                                width:  MediaQuery.of(context).size.width,
                                //height: 100,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 100,
                                          child: Card(
                                            margin: EdgeInsets.only(right: 5,),
                                            elevation: 5.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: _contact(context),
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 100,
                                          child: Card(
                                            margin: EdgeInsets.only(left: 5,),
                                            elevation: 5.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: _cotisation(),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                              _lastEvent(context)
                            ],
                          ),
                        ),)
                  )
              ),
              _header(),
            ],
          ),
        )
    );
  }

  _description(context) {
    if(widget.club.description != "")
      return Container(
        width:  MediaQuery.of(context).size.width,
        child: Card(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Qui sommes nous ?", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: MyTheme.colorTheme(context, colorLight: Colors.black54, colorDark: Colors.white54)),),
                  Container(height: 12,),
                  AutoSizeText(widget.club.description, style: TextStyle(fontSize: 15, ), maxLines:10, textAlign: TextAlign.justify,),
                ]
            ),
          ),
        ),
      );
    else return Container();
  }

  _cotisation() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AutoSizeText("Cotisation", maxLines: 1, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: MyTheme.colorTheme(context, colorLight: Colors.black54, colorDark: Colors.white54) ),),
          Expanded(
            child: Center(
              child: widget.club.price == 0 ? Text("GRATUIT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  : widget.club.price == 100 ? Container()
                  : Text(widget.club.price.toString().replaceAll(".0", "") + " €", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  _contact(context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AutoSizeText("Nous contacter", maxLines: 1, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: MyTheme.colorTheme(context, colorLight: Colors.black54, colorDark: Colors.white54) ),),
          Expanded(
            child: _logocontact(),
          )
        ],
      ),
    );
  }

  _logocontact() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
            flex: 1,
            child: IconButton(
                icon: Icon(FontAwesomeIcons.commentDots, size: 45, color: Theme.of(context).accentColor,),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return Messenger(club: widget.club);
                  }));
                }
            )
        ),
        Flexible(
            flex: 1,
            child:IconButton(
              icon: Icon(FontAwesomeIcons.facebookSquare, size: 45, color: Color(0xFF3b5998),),
              onPressed: () async {_launchWebSite(widget.club.urlFB);},
            )
        ),
        Flexible(
            flex: 1,
            child: widget.club.urlNetwork.contains("youtube") ? IconButton(icon: Icon(FontAwesomeIcons.youtubeSquare, size: 45, color: Color(0xFFc4302b)), onPressed: () async {_launchWebSite(widget.club.urlNetwork);},)
                : widget.club.urlNetwork.contains("instagram") ? IconButton(icon: Icon(FontAwesomeIcons.instagramSquare, size: 45, color: Color(0xFFE1306C)), onPressed: () async {_launchWebSite(widget.club.urlNetwork);},)
                : widget.club.urlNetwork.contains("linkedin") ? IconButton(icon: Icon(FontAwesomeIcons.linkedin, size: 45, color: Color(0xFF0e76a8)), onPressed: () async {_launchWebSite(widget.club.urlNetwork);},)
                : widget.club.urlNetwork != "" ? IconButton(icon: Icon(Icons.link, size: 45, color: Colors.grey[500],), onPressed: () async {_launchWebSite(widget.club.urlNetwork);},)
                : SizedBox(width: 45,)
        ),
      ],
    );
  }

  _launchWebSite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "Ce lien ne fonctionne pas",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos:1,
        backgroundColor: Colors.red.withOpacity(0.75),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  _lastEvent(context) {
    return Container(
      width:  MediaQuery.of(context).size.width,
      child: Container(
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text("Nos derniers événements", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: MyTheme.colorTheme(context, colorLight: Colors.black54, colorDark: Colors.white54) ),),
                ),
                Container(height: 12,),
                nbrEvent == 0 ? Container(margin: EdgeInsets.fromLTRB(30, 0, 30, 30), child: AutoSizeText("Aucun événement cette année", style: TextStyle(fontSize: 15, ), maxLines:10, textAlign: TextAlign.justify,),)
                    : Base.allEvents != null && Base.allEvents.length != 0 ? Container(height: 300,child: buildList())
                    : Container()

              ]
          ),
        ),
      ),
    );
    //else return Container();
  }

  Widget buildList() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Base.allEvents.length,
        itemBuilder: (BuildContext context, int index) {
          return getCover(Base.allEvents[index], context);
        }
    );
  }

  getCover(EventModel event, BuildContext context) {
    EventRepository eventRepository = EventRepository(
      eventApiProvider: EventApiProvider(
        client: Client(),
      ),
    );
    if (event.idClubRef == widget.club.idClubRef && event.enable == true && event.publicationDate.isBefore(DateTime.now())) return EventCard(event, context, eventsBloc: EventsBloc(eventRepository: eventRepository),);
    else return Container();
  }

  _header() {
    return Container(
      height: 500,
      color: Colors.transparent,
      child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: 420,
              child: Card(
                margin: EdgeInsets.fromLTRB(30, 170, 30, 20),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 110),
                  child: Column(
                      children: <Widget>[
                        AutoSizeText(widget.club.name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor), maxLines: 1,),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    AutoSizeText("Membres", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                    AutoSizeText(widget.club.students.length.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                                  ]
                              ),
                              Container(height: 50, child: VerticalDivider(color: Colors.black, width: 2,)),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    AutoSizeText("Événements", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                    _nbrEvent(),
                                  ]
                              ),
                              Container(height: 50, child: VerticalDivider(color: Colors.black, width: 2,)),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    AutoSizeText("Classement", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                    AutoSizeText("à venir", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[100]),),
                                    //AutoSizeText("0", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                                  ]
                              ),
                            ],
                          ),
                        )
                      ]
                  ),
                ),
              ),
            ),
            Positioned(
              top: 95,
              child: GestureDetector(
                child: Hero(
                  tag: 'logoClub'+widget.club.idClubRef.toString(),
                  child: CircleAvatar(
                    backgroundColor: Colors.blueGrey.withOpacity(0.2),
                    radius: 87,
                    child:CircleAvatar(
                      backgroundImage: NetworkImage(widget.club.urlPhoto),
                      backgroundColor: Theme.of(context).backgroundColor,
                      radius:85,
                    ),
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }

  _nbrEvent() {
    if (Base.allEvents != null) {
      if(Base.allEvents.length != 0)
        for(int i = 0; i<Base.allEvents.length; i++) {
          EventModel event = Base.allEvents[i];
          //bool date = event.startDate.isBefore(DateTime(DateTime.now().year, 8, 15));
          bool dateInf = event.startDate.isAfter(DateTime(DateTime.now().year-1, 8, 15));
          if(event.enable && dateInf && event.idClubRef == widget.club.idClubRef) nbrEvent++;
        }

      return AutoSizeText(nbrEvent.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),);
    }
    return AutoSizeText("0", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),);
  }
}