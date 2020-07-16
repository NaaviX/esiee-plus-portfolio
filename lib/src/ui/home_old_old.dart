import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/ui/roles/roles_display.dart';
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

class HomeState extends State<Home> with TickerProviderStateMixin {
  final bloc = ClubsBloc();

  AnimationController _resizableController;

  AnimatedBuilder getContainer() {
    return new AnimatedBuilder(
        animation: _resizableController,
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.all(3 - _resizableController.value * 3 + 10),
            child: Container(
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image:
                    new NetworkImage(user.photoUrl),
                  ),
                )
            ),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.amberAccent.withOpacity(0.8)/*Colors.green.withOpacity(0.8)*/, width: 5 + _resizableController.value * 3),
            ),
          );
        });
  }

  @override
  void initState() {
    if (user == null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return App();
      }));
    }
    super.initState();
    bloc.fetchAllClubs();
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 1000,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    if (Base.thisUser != null) {
      return _homeStudent();
    } else if (Base.thisClub != null) {
      return _homeClub();
    } else if (Base.thisProf != null) {
      return _homeProf();
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _homeClub() {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.all(10.0),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(Base.thisClub.urlPhoto)))),
                            //Flexible(child: Image.network(user.photoUrl)),
                            Text(Base.thisClub.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            RolesDisplay(Base.thisClub.roles),
                          ],
                        ))
                  ])))),
    ]);
  }

  Widget _homeProf() {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.all(10.0),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(user.photoUrl)))),
                          //Flexible(child: Image.network(user.photoUrl)),
                          Text(user.displayName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        ],
                      ),
                    )
                  ]))))
    ]);
  }

  String studentClubs() {
    String studentClubs;
    for(int i=0; i<Base.thisUser.clubs.length;i++) {
      studentClubs += " " + Base.thisUser.clubs[i].name;
    }
    return studentClubs = Base.thisUser.clubs.length.toString();
  }

  Widget _homeStudent() {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //Avatar
                                //getContainer(),
                                Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 250,
                                          width: 250,
                                          child: FlareActor(
                                            "assets/Alarm.flr",
                                            alignment: Alignment.center,
                                            fit: BoxFit.contain,
                                            animation: "Alarm",
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.all(50),
                                            width: 150.0,
                                            height: 150.0,
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
                                //Nom
                                Text(user.displayName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                /*RolesDisplay(Base.thisUser.roles),*/
                                /*Base.thisUser.isContributor
                                    ? Chip(
                                  label: RichText(
                                    text: TextSpan(
                                      text: "Cotisant",),
                                  ),
                                  backgroundColor: Colors.green,
                                )
                                    : Chip(
                                  label: RichText(
                                    text: TextSpan(
                                      text: "Non Cotisant",),
                                  ),
                                  backgroundColor: Colors.red,
                                ),*/
                                /*FutureBuilder<String>(
                                future: getGradeUnitsID(),
                                builder: (BuildContext context, AsyncSnapshot<String> gradeUnitsID){
                                  return Text(gradeUnitsID.data ?? "loading units...");
                                }
                            ),*/
                                Base.thisUser.clubs.length!=0 ? Text(studentClubs()) : Container(),
                              ],
                            ),
                          )
                        ]))),
                _homeStudentUsefulLinks()
              ])),
        ]));
  }

  Widget _homeStudentUsefulLinks() {
    return Card(
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
