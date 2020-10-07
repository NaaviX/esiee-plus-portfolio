import 'dart:convert';

import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/courses_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/grades_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  ClubsBloc clubsBloc = ClubsBloc();
  CourseBloc courseBloc = CourseBloc();
  EventsBloc eventBloc = EventsBloc();
  StudentsBloc studentBloc = StudentsBloc();
  List<ClubModel> studentClub = List();

  @override
  void initState() {
    clubsBloc.fetchAllClubs();
    courseBloc.fetchAllCourses(getGradeUnitsID().toString());
    eventBloc.fetchAllEvents();
    if(Base.thisUser != null) studentBloc.fetchAllStudentClubs(Base.thisUser);
    super.initState();
  }

  @override
  void dispose() {
    clubsBloc.dispose();
    courseBloc.dispose();
    eventBloc.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 80),
              child: SingleChildScrollView(
                //padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5,),
                    StreamBuilder(
                        stream: studentBloc.thisStudentClubs,
                        builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
                          return snapshot.hasData
                              ? _Component('Mes Clubs', 0, snapshot.data)
                              : Container();
                        }
                    ),
                    _Component('Mon Prochain Cours', 1),
                    _Component('Top Events', 2),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child:_Links(),
            ),
          ],
        )
    );
  }

  _Component(String title, int type, [List<ClubModel> clubs]) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(title, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.w900),),
            ),
            type == 0 ? _StudentClub(clubs) :
            type == 1 ? _StudentNextCurses() :
            type == 2 ? _TopEvents() :
            Container()
          ],
        )
    );
  }

  _TopEvents() {
    List<EventModel> tops = List();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: StreamBuilder(
          stream: eventBloc.allEvents,
          builder: (BuildContext context, AsyncSnapshot<List<EventModel>> events) {
            if (events.hasData) {
              events.data.removeWhere((event) => !event.enable || event.startDate.isBefore(DateTime.now()));
              if(events.data.isEmpty) return Text("Aucun évenement à venir... 😭", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w600),);
              tops.addAll(events.data.where((event) => event.enabledStratif));
              tops.isEmpty ? tops.add(events.data.last) : tops=tops;
              return _TopEventsList(tops);
            }
            return Container();
          }
      ),
    );
  }

  _TopEventsList(List<EventModel> tops) {
    return Card(
      elevation: 0,

    );
  }

  Future<String> getLocalCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('coursesJson');
    return localEvents;
  }

  _StudentNextCurses() {
    return TimerBuilder.periodic(
        Duration(minutes: 1),
        builder: (context) {
          return FutureBuilder(
              future: getLocalCourses(),
              builder: (BuildContext context, AsyncSnapshot<String> eventsJson) {
                if (eventsJson.hasData) {
                  dynamic jsonData = jsonDecode(eventsJson.data);
                  List<CourseModel> snapshot = CourseModel.allCoursesFromJson(jsonData).toList();
                  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute-30);
                  CourseModel course = snapshot.firstWhere((course) => now.isBefore(course.start) && now.isBefore(course.end));
                  return _StudentNextCursesCard(course);
                }
                return Container();
              }
          );
        }
    );
  }

  _StudentNextCursesCard(CourseModel course) {
    String place = course.location.replaceAll("[", '').replaceAll("]", '');

    int diffDay = 0;
    Duration diffTime = Duration(hours: 0);
    String diff;
    DateTime.now().day != course.start.day ?
    diffDay = course.start.day-DateTime.now().day :
    diffTime = course.start.difference(DateTime.now());
    course.start.isBefore(DateTime.now()) || course.start == DateTime.now() ? diff = "En cours" :
    diffDay < -7 ? diff = "Dans " + (diffDay.abs()/7).toString().split('.').first + " semaines" :
    diffDay == 1 ? diff = "Demain à " + DateFormat("HH:mm","fr_FR").format(course.start) :
    diffDay > 1 ? diff = DateFormat("EEE à HH:mm","fr_FR").format(course.start) :
    diffTime.inHours >= 1 ? diff = "Dans " + diffTime.inHours.toString() + "h" + (diffTime.inMinutes%60).toString() + "min" :
    diff = "Dans " + (diffTime.inMinutes%60).toString() + "min";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        //color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blueAccent.withOpacity(0.8), Colors.blueAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0)
              ),
              constraints: BoxConstraints(minHeight: 150.0),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 125),
                    child: Text(course.type + ' : ' + course.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Text('Enseigné par ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),),
                      Text(course.teachers.replaceAll("[", '').replaceAll("]", ''), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text('De ' + DateFormat("HH:mm","fr_FR").format(course.start) + ' à ' + DateFormat("HH:mm","fr_FR").format(course.end), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),),
                  SizedBox(height: 5),
                  Text(course.group.replaceAll("[", '').replaceAll("]", ''), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 10,
              child: Chip(backgroundColor: Colors.white30,label: Container(padding: EdgeInsets.symmetric(horizontal: 2), child : Center(child: Text(diff, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor)),)), padding: EdgeInsets.all(0), ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child:
              place == 'Classe virtuelle' ?
              Icon(Icons.home, color: Colors.white, size: 25,) :
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, color: Colors.white, size: 15,),
                  Text(place, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StudentClub(List<ClubModel> clubs) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 80,
        //child:
        child:
        ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: clubs.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.withOpacity(0.2),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(clubs[index].urlPhoto),
                    backgroundColor: Colors.white,
                    radius: 35,
                  ),
                  radius: 38,
                ),
              );
            }
        )
  );
}

_Links() {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    //height: 62,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _homeStudentUsefulLinks("Webaurion", "https://webaurion.esiee.fr/", "https://media-exp1.licdn.com/dms/image/C4D0BAQFbOzrZBcQXgA/company-logo_200_200/0?e=2159024400&v=beta&t=TzGOdwYwDfAOQ51SmYuSV6XaC8-uHv39pj-xLw3H2y0"),
        _homeStudentUsefulLinks("Blackboard", "https://esiee.blackboard.com/", "https://www.osa.fu-berlin.de/studieneinstieg/en/_media/grafiken/BlackboardMobileLearnAppIcon.png"),
        _homeStudentUsefulLinks("ICampus", "https://icampus.esiee.fr/", "https://enovationsolutions.fr/wp-content/uploads/2018/02/moodle-logo-300x225.png"),
        _homeStudentUsefulLinks("Intra", "https://intra.esiee.fr/", "https://www.esiee.fr/sites/all/themes/custom/esiee_theme/logo.png"),
      ],
    ),
  );
}

_homeStudentUsefulLinks(String nom, String site, String image,) {
  return InkWell(
    child: Container(
      padding: EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: 40.0,
              height: 40.0,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.scaleDown,
                  image:
                  new NetworkImage(image),
                ),
              )
          ),
          Text(nom, style: TextStyle(fontSize: 10, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),),
        ],
      ),
    ),
    customBorder: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(10.0),
    ),
    onTap: () async {
      await launch(site);
    },
  );
}
}
