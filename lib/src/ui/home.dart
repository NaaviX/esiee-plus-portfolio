import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'event_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Container(
          margin: EdgeInsets.all(10.0),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(children: <Widget>[
                    Expanded(child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        user.photoUrl)
                                )
                            )),
                        //Flexible(child: Image.network(user.photoUrl)),
                        Text(user.displayName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Cotisant ?"),
                        Text("Roles")
                      ],
                    ),
                    )])))),
      Expanded(child: EventList())
    ]));
  }
}
