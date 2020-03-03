//When user (Club) click on add button
import 'package:bde_esiee_mobile/src/resources/translations.dart';
import 'package:flutter/material.dart';

class EventCreation extends StatelessWidget{

  @override Widget build(BuildContext context){
    return new Scaffold(
        appBar: AppBar(
          title: new Text(Translations.of(context).text("newevent")),
        ),
    );
  }
}