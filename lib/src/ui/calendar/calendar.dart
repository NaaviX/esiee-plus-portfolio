import 'dart:math';

import 'package:bde_esiee_mobile/src/blocs/courses_bloc.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/agenda_event_view.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/gradeUnits_list.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/week_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import 'grades/grade_list.dart';

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

   @override
   Widget build(BuildContext context){
     return Scaffold(
         body: StreamBuilder(
             stream: bloc.allCourses,
             builder: (context, AsyncSnapshot<List<CourseModel>> snapshot) {
               if (snapshot.hasData) {
                 return buildAgenda(snapshot);
               } else if (snapshot.hasError) {
                 return Text(snapshot.error.toString());
               }
               return Center(child: CircularProgressIndicator());
             }
         ),
         floatingActionButton: FloatingActionButton(
           onPressed: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => GradesList()),
             );
           },
           child: Icon(Icons.settings),
           backgroundColor: Colors.blue,
         )
     );
   }

  Widget buildAgenda(AsyncSnapshot<List<CourseModel>> snapshot) {
    return WeekView(
      initialHour: 7,
      dates: getWeekDates(),
      hoursColumnWidth: 40,
      dayViewWidth: (MediaQuery.of(context).size.width-40)/7,
      events: toAgendaEventList(snapshot),
      dateFormatter: f,
      userZoomable: false,
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getGradeID(),
            initialData: "Loading text..",
            builder: (BuildContext context, AsyncSnapshot<String> gradeID) {
              return Scaffold(
                  body: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(gradeID.data != null ? "Numéro de l'unité : ${gradeID.data}" : "Can't find text"),
                        FutureBuilder(
                            future: getGradeUnitsID(),
                            initialData: "Loading text..",
                            builder: (BuildContext context, AsyncSnapshot<String> gradeUnitsID) {
                              return Text(gradeUnitsID.data != null ? "Groupes suivies : ${gradeUnitsID.data}" : "Can't find text");
                            }
                        )
                      ]
                  )
                    );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GradesList()),
            );
          },
          child: Icon(Icons.settings),
          backgroundColor: Colors.blue,
        )
    );
  }*/

  List<AgendaEventView> toAgendaEventList(AsyncSnapshot<List<CourseModel>> courses){
    List<AgendaEventView> agendaEvents = [];
    courses.data.forEach((course) {
      agendaEvents.add(
        AgendaEventView(
            course: course,
          backgroundColor: Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(0.7)
        )
      );
    });
    return agendaEvents;
  }

  String f(int a, int b, int c){
    return DateFormat('E', "fr FR").format(DateTime(a, b, c)).substring(0,1).toUpperCase()+DateFormat('\nd/MM').format(DateTime(a, b, c));
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
}