//When user click on a club
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClubInfoPage extends StatefulWidget{

  final ClubModel club;
  ClubInfoPage({this.club});

  @override
  State<StatefulWidget> createState() {
  return ClubInfoPageState();
  }
}

class ClubInfoPageState extends State<ClubInfoPage>  /*with AutomaticKeepAliveClientMixin*/ {

  @override
  final events = EventsBloc();

  @override
  void initState() {
    super.initState();
    events.fetchAllEvents();
  }

  @override
  void dispose() {
    super.dispose();
    events.dispose();
  }

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.club.name),
        ),
        body: Column(
          children: <Widget>[
            Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/bde-esiee-mobile.appspot.com/o/clubs%2Fcouv%2FNIX_couv.png?alt=media&token=81f5104f-5060-419f-bc8f-4957a63ac077")
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  Container(
                    height: 400,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(30, 150, 30, 20),
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 110),
                        child: Column(
                            children: <Widget>[
                              AutoSizeText(widget.club.name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,), maxLines: 1,),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          AutoSizeText("Membres", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                          AutoSizeText(widget.club.students.length.toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
                                        ]
                                    ),
                                    Container(height: 50, child: VerticalDivider(color: Colors.black, width: 2,)),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          AutoSizeText("Evénements", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                          StreamBuilder(
                                              stream: events.allEvents,
                                              builder: (context, AsyncSnapshot<List<EventModel>> snapshot) {
                                                if (snapshot.hasData) {
                                                  return AutoSizeText(_nbrEvent(snapshot), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),);
                                                }
                                                else if (snapshot.hasError) {
                                                  return Text(snapshot.error.toString());
                                                }
                                                return Center(child: CircularProgressIndicator());
                                              }
                                          ),
                                        ]
                                    ),
                                    Container(height: 50, child: VerticalDivider(color: Colors.black, width: 2,)),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          AutoSizeText("Classement", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                          AutoSizeText("3", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
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
                    top:50 ,
                    child: GestureDetector(
                      child: Hero(
                        tag: 'logoClub'+widget.club.idClubRef.toString(),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.club.urlPhoto),
                          backgroundColor: Colors.white,
                          radius:100,
                        ),
                      ),
                    ),
                  ),
                ]
            ),
            //_contact(context),
            _description(context),
          ],
        )
    );
  }

  _description(context) {
    if(widget.club.description != "")
      return Container(
        width:  MediaQuery.of(context).size.width,
        child: Card(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Qui sommes nous ?", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.black54 ),),
                  Container(height: 12,),
                  AutoSizeText(widget.club.description, style: TextStyle(fontSize: 15, ), maxLines:10, textAlign: TextAlign.justify,),
                ]
            ),
          ),
        ),
      );
    else return Container();
  }

  String _nbrEvent(AsyncSnapshot<List<EventModel>> snapshot) {
    int nbrEvent = 0;
    for(int i = 0; i<snapshot.data.length; i++) {
      EventModel event = snapshot.data[i];
      bool date = event.startDate.isBefore(DateTime(DateTime.now().year, 8, 15));
      bool dateInf = event.startDate.isAfter(DateTime(DateTime.now().year-1, 8, 15));
      if(event.enable && dateInf && event.idClubRef == widget.club.idClubRef) nbrEvent++;
    }
    return nbrEvent.toString();
  }
}