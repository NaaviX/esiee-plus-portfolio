import 'dart:convert';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/agenda_event_view.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/week_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller.dart';
import 'dart:math';

class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {

  final log = Logger('Calendar');

  Future<String> getLocalCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('coursesJson');
    return localEvents;
  }

  WeekViewController scrollController = WeekViewController(dayViewsCount: 7*7);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: buildLocal()
    );
  }

  Widget buildLocal(){
    return FutureBuilder(
        future: getLocalCourses(),
        builder: (BuildContext context, AsyncSnapshot<String> eventsJson) {
          if (eventsJson.hasData) {
            dynamic jsonData = jsonDecode(eventsJson.data);
            List<CourseModel> snapshot = CourseModel.allCoursesFromJson(jsonData).reversed.toList();
            return buildAgenda(snapshot);
          }
          return Container();
        }
    );
  }

  void scrollToCurrentTime() {

    int index = 2 * 7;
    index -= index % 7;

    double dayViewWidth = (MediaQuery.of(context).size.width-40)/7;
    double leftOffset = dayViewWidth * index;

    double calculateTopOffset(int hour, [int minute = 0, double hourRowHeight]) => (hour + (minute / 60)) * 60;

    scrollController.verticalScrollController.animateTo( min(calculateTopOffset(7, 50), scrollController.verticalScrollController.position.maxScrollExtent), duration: Duration(seconds: 1), curve: Curves.easeOut );
    scrollController.horizontalScrollController.animateTo( min(leftOffset, scrollController.horizontalScrollController.position.maxScrollExtent), duration: Duration(seconds: 1), curve: Cubic(0.175, 0.885, 0.32, 1.125) );
  }

  Widget buildAgenda(List<CourseModel> snapshot) {
    return WeekView(
      initialHour: 7,
      initialMinute: 50,
      dates: getWeekDates(2, 4),
      hoursColumnWidth: 40,
      dayViewWidth: (MediaQuery.of(context).size.width-40)/7,
      events: toAgendaEventList(snapshot),
      dateFormatter: f,
      inScrollableWidget: true,
      userZoomable: false,
      controller: scrollController,
    );
  }

  Widget buildEmptyAgenda() {
    return WeekView(
      initialHour: 6,
      initialMinute: 50,
      dates: getWeekDates(0, 0),
      hoursColumnWidth: 40,
      dayViewWidth: (MediaQuery.of(context).size.width-40)/7,
      dateFormatter: f,
      inScrollableWidget: true,
      userZoomable: false,
    );
  }

  List<AgendaEventView> toAgendaEventList(List<CourseModel> courses){
    List<AgendaEventView> agendaEvents = [];
    courses.forEach((course) {
      agendaEvents.add(
          AgendaEventView(
              course: course,
              backgroundColor: course.color
          )
      );
    });
    return agendaEvents;
  }

  String f(int a, int b, int c){
    String dayLetter = DateFormat('E', "fr FR").format(DateTime(a, b, c)).substring(0,1).toUpperCase();
    //String DayNum = DateFormat('\nd').format(DateTime(a, b, c));
    return dayLetter;// + DayNum;
  }

  List<DateTime> getWeekDates(int weekUntilToday, int weekAfterToday){
    DateTime start = DateTime.now().subtract(Duration(days: weekUntilToday*7 + DateTime.now().weekday-1 ));
    int days = ( weekUntilToday + weekAfterToday + 1) * 7 ;
    List<DateTime> yearDays = new List<DateTime>.generate(days, (index) => start.add(Duration(days: index)));
    //yearDays.removeWhere((element) => element.weekday == 7);
    return yearDays;
  }
}