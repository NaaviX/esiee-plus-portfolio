import 'dart:convert';

import 'package:bde_esiee_mobile/src/blocs/courses_bloc.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/agenda_event_view.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/week_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calendar extends StatefulWidget {
  final String ids;
  Calendar({@required this.ids});

  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {

  final log = Logger('Calendar');
  final bloc = CourseBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchAllCourses(widget.ids);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Future<String> getLocalCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('coursesJson');
    return localEvents;
  }

   @override
   Widget build(BuildContext context){
     return Scaffold(
         body: StreamBuilder(
             stream: bloc.allCourses,
             builder: (context, AsyncSnapshot<List<CourseModel>> snapshot) {
               if (!snapshot.hasData) {
                 return FutureBuilder(
                     future: getLocalCourses(),
                     builder: (BuildContext context, AsyncSnapshot<String> eventsJson) {
                       if (eventsJson.hasData) {
                         dynamic jsonData = jsonDecode(eventsJson.data);
                         List<CourseModel> snapshot = CourseModel.allCoursesFromJson(jsonData).reversed.toList();
                         return buildAgenda(snapshot);
                       }
                       return Center(child: CircularProgressIndicator());
                     }
                 );
               } else if (snapshot.hasError) {
                 return Text(snapshot.error.toString());
               }
               return buildAgenda(snapshot.data);
             }
         )
     );
   }

  Widget buildAgenda(List<CourseModel> snapshot) {
    return WeekView(
      initialHour: 6,
      initialMinute: 50,
      dates: getWeekDates(10, 8),
      hoursColumnWidth: 40,
      dayViewWidth: (MediaQuery.of(context).size.width-40)/7,
      events: toAgendaEventList(snapshot),
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
    return DateFormat('E', "fr FR").format(DateTime(a, b, c)).substring(0,1).toUpperCase()+DateFormat('\nd/MM').format(DateTime(a, b, c));
  }

  List<DateTime> getWeekDates(int weekUntilToday, int weekAfterToday){
    DateTime start = DateTime.now().subtract(Duration(days: weekUntilToday*7 + DateTime.now().weekday-1 ));
    int days = ( weekUntilToday + weekAfterToday + 1) * 7 ;
    List yearDays = new List<DateTime>.generate(days, (index) => start.add(Duration(days: index)));
    return yearDays;
  }
}