import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../App.dart';
import 'event/event_list.dart';
import 'login_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final bloc = ClubsBloc();

  @override
  void initState() {
    if (user == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return App();
      }));
    }
    super.initState();
    bloc.fetchClub(user.email);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //club
    return StreamBuilder(
      stream: bloc.thisClub,
      builder: (context, AsyncSnapshot<ClubModel> snapshot) {
        if (snapshot.hasData) {
          return _homeClub(snapshot.data);
        } else if (user.email.endsWith("gmail.com")) {
          //change to @esiee.fr
          return _homeProf();
        } else if (user.email.endsWith("edu.esiee.fr")) {
          return _homeStudent();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _homeClub(ClubModel club) {
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
                                    image: new NetworkImage(club.logoUrl)))),
                        //Flexible(child: Image.network(user.photoUrl)),
                        Text(club.title,
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
                          Text("Cotisant ?"),
                          Text("Roles")
                        ],
                      ),
                    )
                  ])))),
      Expanded(child: EventList())
    ]);
  }
}
