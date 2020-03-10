import 'package:bde_esiee_mobile/src/ui/agenda/event.dart';
import 'package:bde_esiee_mobile/src/ui/agenda/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Agenda extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AgendaState();
  }
}

class AgendaState extends State<Agenda> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        weekView(date: DateTime.now()),
        Positioned(
          top: 0,
          left: 0,
          child: HourBar(),
        )
      ],
    );
  }

  String f(int a, int b, int c){
    return DateFormat('E\nd').format(DateTime(a, b, c));
  }

  List<FlutterWeekViewEvent> getCourses(){
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return [
      FlutterWeekViewEvent(
        title: 'Infographie 3D(Unity II)',
        description: 'A description 1',
        start: date.add(Duration(hours: 13)),
        end: date.add(Duration(hours: 15)),
      )
    ];
  }

  List<DateTime> getDates(){
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return [
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 1)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 2)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 3)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 4)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 5)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 6)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 7)),
    ];
  }

  List<DateTime> getDates2(){
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return [
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 8)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 9)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 10)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 11)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 12)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 13)),
      date.subtract(Duration(days: date.weekday)).add(Duration(days: 14)),
    ];
  }

  String changeToLetter(DateTime date){
    return DateFormat('EEEE').format(date);
  }
}

