import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class Timecalendar extends StatelessWidget {
  final log = Logger('timecalendar');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text(
          'EDT',
        )
    );
  }
}