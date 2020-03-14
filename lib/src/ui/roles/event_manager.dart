import 'package:bde_esiee_mobile/src/ui/event/disabled__event.dart';
import 'package:flutter/material.dart';

class EventManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Gestion des évènements"),
    ),
    body:DisabledEventList());
  }


}