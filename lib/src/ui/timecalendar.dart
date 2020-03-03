import 'package:bde_esiee_mobile/src/resources/translations.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class Timecalendar extends StatelessWidget {
  final log = Logger('timecalendar');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Text(
          Translations.of(context).text("edt"),
        )
    );
  }
}