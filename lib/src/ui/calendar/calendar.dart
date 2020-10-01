import 'dart:convert';

import 'package:bde_esiee_mobile/src/blocs/courses_bloc.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/agenda_event_view.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/week_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller.dart';

class Calendar extends StatefulWidget {
  final String ids;
  Calendar({this.ids});

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

  /*Future<bool> isInternetConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }*/

  Future<String> getLocalCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('coursesJson');
    return localEvents;
  }

  WeekViewController scrollController;

   @override
   Widget build(BuildContext context){
     WeekViewController scrollController = WeekViewController(dayViewsCount: getWeekDates(2, 5).length);
     return Scaffold(
         body:buildLocal()
     );
     /*StreamBuilder(
             stream: bloc.allCourses,
             builder: (context, AsyncSnapshot<List<CourseModel>> snapshot) {
               if (!snapshot.hasData) {

                 return buildLocal();
               } else if (snapshot.hasError) {
                 return Text(snapshot.error.toString());
               }

               if(snapshot.data.length == 0){

               }
               return buildAgenda(snapshot.data);
             }
       ),*/
       /*floatingActionButton: FloatingActionButton(
           child: Icon(Icons.adjust, color: Colors.yellowAccent,),
           splashColor: Colors.white,
           onPressed: () {
           }
       ),*/
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

    /// Calculates the top offset of a given hour and a given minute.
    double calculateTopOffset(int hour, [int minute = 0, double hourRowHeight]) => (hour + (minute / 60)) * 40;

    /// Calculates the widget height.
    double calculateHeight([double hourRowHeight]) => calculateTopOffset(24, 0, hourRowHeight);

    //scrollController.verticalScrollController.jumpTo(math.min(calculateTopOffset(6, 50), scrollController.verticalScrollController.position.maxScrollExtent));
    //scrollController.horizontalScrollController.jumpTo(math.min(leftOffset, scrollController.horizontalScrollController.position.maxScrollExtent));
  }

  Widget buildAgenda(List<CourseModel> snapshot) {
    return WeekView(
      initialHour: 6,
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
     String DayLetter = DateFormat('E', "fr FR").format(DateTime(a, b, c)).substring(0,1).toUpperCase();
     String DayNum = DateFormat('\nd').format(DateTime(a, b, c));
     return DayLetter + DayNum;
  }

  List<DateTime> getWeekDates(int weekUntilToday, int weekAfterToday){
    DateTime start = DateTime.now().subtract(Duration(days: weekUntilToday*7 + DateTime.now().weekday-1 ));
    int days = ( weekUntilToday + weekAfterToday + 1) * 7 ;
    List yearDays = new List<DateTime>.generate(days, (index) => start.add(Duration(days: index)));
    return yearDays;
  }
}