import 'package:flutter/material.dart';

class BdeInfos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Informations BDE"),
    ),
    body:ListView(children: <Widget>[
      ListTile(title: Text("SIRET : XXXXXXXXXXXXXXX"),),
      ListTile(title: Text("IBAN : FRXX XXXX XXXX XXXX XXXX XX"),)
    ],));
  }


}