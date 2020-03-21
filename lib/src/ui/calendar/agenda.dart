import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/agenda_event_view.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/week_view.dart';
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
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday-1));
    return [
      AgendaEventView(
          course: CourseModel(
              title: 'An event 1',
              description: 'A description 1',
              start: date.add(const Duration(hours: 8, minutes: 00)),
              end: date.add(const Duration(hours: 10, minutes: 00))
          ),
          backgroundColor: Colors.blueAccent
      ),
      AgendaEventView(
          course: CourseModel(
              title: 'An event 2',
              description: 'A description 2',
              start: date.add(const Duration(hours: 10, minutes: 00)),
              end: date.add(const Duration(hours: 12, minutes: 00))
          ),
          backgroundColor: Colors.amber
      ),
      AgendaEventView(
        course: CourseModel(
            title: 'An event 3',
            description: 'A description 3',
            start: date.add(const Duration(hours: 13, minutes: 00)),
            end: date.add(const Duration(hours: 17, minutes: 00))
        ),
      ),
      AgendaEventView(
          course: CourseModel(
              title: 'An event 4',
              description: 'A description 4',
              start: date.add(const Duration(days: 1, hours: 8, minutes: 00)),
              end: date.add(const Duration(days: 1, hours: 12, minutes: 00)))
      ),
      AgendaEventView(
          course: CourseModel(
              title: 'An event 5',
              description: 'A description 5',
              start: date.add(const Duration(days: 2, hours: 8, minutes: 00)),
              end: date.add(const Duration(days: 2, hours: 13, minutes: 00)))
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

  String changeToLetter(DateTime date){
    return DateFormat('EEEE').format(date);
  }

  AgendaEventView toAgendaEvent(CourseModel course){
    return AgendaEventView(
      course: course
    );
  }

}

