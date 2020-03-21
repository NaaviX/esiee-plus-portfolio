import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/grades_utils.dart';
import 'package:bde_esiee_mobile/src/ui/roles/roles_display.dart';
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

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final bloc = ClubsBloc();

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
                                    image: new NetworkImage(user.photoUrl)))),
                        //Flexible(child: Image.network(user.photoUrl)),
                        Text(Base.thisClub.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
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
                          Text(user.displayName,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ]))))
    ]);
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
                            Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            new NetworkImage(user.photoUrl)))),
                            //Nom
                            Text(user.displayName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Base.thisUser.contributor
                                ? Chip(
                                    label: RichText(
                                      text: TextSpan(
                                          text: "Cotisant",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    backgroundColor: Colors.green,
                                  )
                                : Chip(
                                    label: RichText(
                                      text: TextSpan(
                                          text: "Non Cotisant",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                            FutureBuilder<String>(
                                future: getGradeUnitsID(),
                                builder: (BuildContext context, AsyncSnapshot<String> gradeUnitsID){
                                  return Text(gradeUnitsID.data ?? "loading units...");
                                }
                            ),
                            RolesDisplay(Base.thisUser.roles)
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
