import 'package:bde_esiee_mobile/src/ui/agenda/agenda_event_view.dart';
import 'package:bde_esiee_mobile/src/ui/agenda/week_view.dart';
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
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return WeekView(
      initialHour: 7,
      dates: getWeekDates(),
      hoursColumnWidth: 40,
      dayViewWidth: (MediaQuery.of(context).size.width-40)/7,
      events: getCourses(),
      dateFormatter: f,
      userZoomable: false,
    );
  }

  String f(int a, int b, int c){
    return DateFormat('E', "fr FR").format(DateTime(a, b, c)).substring(0,1).toUpperCase()+DateFormat('\nd/MM').format(DateTime(a, b, c));
  }

  List<AgendaEventView> getCourses(){
    DateTime now = DateTime.now().subtract(Duration(days: 5));
    DateTime date = DateTime(now.year, now.month, now.day);
    return [
      AgendaEventView(
        title: 'An event 1',
        description: 'A description 1',
        start: date.add(const Duration(hours: 8, minutes: 00)),
        end: date.add(const Duration(hours: 10, minutes: 00)),
        backgroundColor: Colors.blueAccent
      ),
      AgendaEventView(
        title: 'An event 2',
        description: 'A description 2',
        start: date.add(const Duration(hours: 10, minutes: 00)),
        end: date.add(const Duration(hours: 12, minutes: 00)),
        backgroundColor: Colors.amber
      ),
      AgendaEventView(
        title: 'An event 3',
        description: 'A description 3',
        start: date.add(const Duration(hours: 13, minutes: 00)),
        end: date.add(const Duration(hours: 17, minutes: 00)),
      ),
      AgendaEventView(
        title: 'Pré-TOEIC Skills Building',
        description: 'A description 4',
        start: date.add(const Duration(days: 1, hours: 8, minutes: 00)),
        end: date.add(const Duration(days: 1, hours: 12, minutes: 00)),
      ),
      AgendaEventView(
        title: 'Deep learning 1 ',
        description: 'A description 5',
        start: date.add(const Duration(days: 2, hours: 8, minutes: 00)),
        end: date.add(const Duration(days: 2, hours: 13, minutes: 00)),
      ),
    ];
  }

  List<DateTime> getWeekDates(){
    DateTime now = DateTime.now();
    DateTime monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday));
    return [
      monday.add(Duration(days: 1)),
      monday.add(Duration(days: 2)),
      monday.add(Duration(days: 3)),
      monday.add(Duration(days: 4)),
      monday.add(Duration(days: 5)),
      monday.add(Duration(days: 6)),
      monday.add(Duration(days: 7)),
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

