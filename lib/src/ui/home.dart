import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../App.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            _header(context),
            Base.thisUser!=null ? _homeStudentUsefulLinks() : Container(),
          ],
        )

    );
  }

  _header(BuildContext context) {
    return Container(
      color: PrimaryColor.withOpacity(0.8),
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height/3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
              children: [
                Base.thisUser != null && Base.thisUser.isContributor ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 200,
                    width: 200,
                    child: FlareActor(
                      "assets/Alarm.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "Alarm",
                    ),
                  ),
                ) : Container(height: 175,),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: Base.thisUser != null && !Base.thisUser.isContributor ? EdgeInsets.only(top: 30) : EdgeInsets.only(top: 40),
                      width: 120.0,
                      height: 120.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image:
                          new NetworkImage(user.photoUrl),
                        ),
                      )
                  ),
                ),
              ]
          ),
          Text(user.displayName, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white,),),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              children:
              Base.thisUser != null && Base.thisUser.isContributor ? _ListStudentClub() :
              Base.thisUser != null && !Base.thisUser.isContributor ?
              [Chip(
                label: Text("Eleve", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color : Colors.white)),
                backgroundColor: PrimaryColor,
              )] :
              Base.thisClub != null ?
              [Chip(
                label: Text("Club", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color : Colors.white)),
                backgroundColor: PrimaryColor,
              )] :
              Base.thisProf != null ? _ListProfUnits() : [Container()],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _ListStudentClub() {
    List<Widget> list = List<Widget>();
    list.add(_ContributorMedal());
    list.add(
      Container(
          width: 30.0,
          height: 30.0,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image:
              new NetworkImage("https://firebasestorage.googleapis.com/v0/b/bde-esiee-mobile.appspot.com/o/clubs%2FBDE.png?alt=media&token=85e40648-55ce-4096-8f5b-fc0ce5955167"),
            ),
          )
      ),
    );
    list.add(
      Container(
          width: 30.0,
          height: 30.0,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image:
              new NetworkImage("https://firebasestorage.googleapis.com/v0/b/bde-esiee-mobile.appspot.com/o/clubs%2FFZY.png?alt=media&token=cdb5de46-6b14-4d1b-b387-ac31541737d4"),
            ),
          )
      ),
    );
    return list;
  }

  _ContributorMedal() {
    return Container(
      width: 30.0,
      height: 30.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        //color: Colors.white,
      ),
      child: Container(
        width: 30.0,
        height: 30.0,
        child: FlareActor(
          "assets/medal.flr",
          alignment: Alignment.center,
          fit: BoxFit.fill,
          animation: "default",
        ),
      ),
    );
  }

  List<Widget> _ListProfUnits() {
    List<Widget> list = List<Widget>();
    Base.thisProf.units.forEach((element) {list.add(
        Chip(
          label: Text(element.unitCode, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color : Colors.white)),
          backgroundColor: PrimaryColor,
        )
    );});
    return list;
  }

  Widget _homeStudentUsefulLinks() {
    return Card(
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(children: <Widget>[
              Expanded(
                  child:
                  Column(mainAxisSize: MainAxisSize.min, children: <
                      Widget>[
                    Container(
                        width: 122.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "https://www.esiee.fr/sites/all/themes/custom/esiee_theme/logo.png")))),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                      title: Text("Webaurion"),
                      leading: Icon(Icons.info),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () async {
                        await launch("https://webaurion.esiee.fr/");
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                      title: Text("Blackboard"),
                      leading: Icon(Icons.info),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () async {
                        await launch("https://esiee.blackboard.com/");
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                      title: Text("Intra"),
                      leading: Icon(Icons.info),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () async {
                        await launch("https://intra.esiee.fr/");
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                      title: Text("Icampus"),
                      leading: Icon(Icons.info),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () async {
                        await launch("https://icampus.esiee.fr/");
                      },
                    )
                  ])),
            ])));
  }
}
