import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../App.dart';
import 'event/event_list.dart';

class Home extends StatefulWidget {
  final StudentModel thisUser;
  final ClubModel thisClub;
  const Home(this.thisUser, this.thisClub);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (user == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return App();
      }));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.thisUser != null) {
      return _homeStudent();
    } else if(widget.thisClub != null) {
      return _homeClub();
    } else {
      return _homeProf();
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
                                    image: new NetworkImage(widget.thisClub.logoUrl)))),
                        //Flexible(child: Image.network(user.photoUrl)),
                        Text(widget.thisClub.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ))
                  ])))),
      Expanded(child: EventList())
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
                          Text(widget.thisUser.contributor ? "Cotisant" : "Non cotisant"),
                          _getRoles()
                        ],
                      ),
                    )
                  ])))),
    ]);
  }

  _getRoles() {
    String roles = "";
    for(var i = 0; i < widget.thisUser.roles.length; i++) {
      roles += widget.thisUser.roles.elementAt(i).role+" ";
    }
    return Text(roles);
  }
}
