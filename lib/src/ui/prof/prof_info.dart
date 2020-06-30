import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:flutter/material.dart';

class ProfInfoPage extends StatelessWidget{

  final ProfModel prof;
  ProfInfoPage({this.prof});

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(prof.firstname+" "+prof.lastname),
        ),
        body: Column(children: <Widget>[
          Center(
              child: Image.network(
                prof.urlPhoto,
              )
          ), Center(child: Text("Bureau : "+prof.office),),
          Center(child: Text("Téléphone : "+prof.phone),),
          prof.units.length != 0 ? Center(child: Text("Unitées : "+prof.units.first.unitName),) : Container(),
        ],)
    );
  }
}