import 'package:bde_esiee_mobile/src/ui/event/event_list.dart';
import 'package:flutter/material.dart';

class EventManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Gestion des évènements"),
    ),
      body:EventList(moderation: true,)
    );
  }


}