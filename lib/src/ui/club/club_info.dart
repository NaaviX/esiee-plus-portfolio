//When user click on a club
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClubInfoPage extends StatelessWidget{

  final ClubModel club;
  ClubInfoPage({this.club});

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(club.name),
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
                          image: NetworkImage("https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/58373256_2184091388372532_6829136169737912320_o.png?_nc_cat=105&_nc_sid=dd9801&_nc_ohc=hLHSh8tWyykAX98Tkj9&_nc_ht=scontent-cdt1-1.xx&oh=3b211fd411430d2df6fbf0e16b40467b&oe=5EA2D979")
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
                              AutoSizeText(club.name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,), maxLines: 1,),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          AutoSizeText("Membres", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                          AutoSizeText("27", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
                                        ]
                                    ),
                                    Container(height: 50, child: VerticalDivider(color: Colors.black, width: 2,)),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          AutoSizeText("Evénements", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                          AutoSizeText("27", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
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
                        tag: 'logoClub'+club.idClubRef.toString(),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(club.urlPhoto),
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
    if(club.description != "")
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
                  AutoSizeText(club.description, style: TextStyle(fontSize: 15, ), maxLines:10, textAlign: TextAlign.justify,),
                ]
            ),
          ),
        ),
      );
    else return Container();
  }
}