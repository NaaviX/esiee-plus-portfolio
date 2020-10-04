import 'dart:convert';

import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/courses_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/grades_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    clubsBloc.fetchAllClubs();
    courseBloc.fetchAllCourses(getGradeUnitsID().toString());
    super.initState();
  }

  @override
  void dispose() {
    clubsBloc.dispose();
    courseBloc.dispose();
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
                    _Component('Mes Clubs', 0),
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

  _Component(String title, int type) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(title, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.w900),),
            ),
            type == 0 ? _StudentClub() :
            type == 1 ? _StudentNextCurses() :
            type == 2 ? Container() :
            Container()
          ],
        )
    );
  }

  Future<String> getLocalCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('coursesJson');
    return localEvents;
  }

  _StudentNextCurses() {
    return FutureBuilder(
        future: getLocalCourses(),
        builder: (BuildContext context, AsyncSnapshot<String> eventsJson) {
          if (eventsJson.hasData) {
            dynamic jsonData = jsonDecode(eventsJson.data);
            List<CourseModel> snapshot = CourseModel.allCoursesFromJson(jsonData).toList();
            CourseModel course = snapshot.firstWhere((course) => (DateTime.now().isAfter(course.start) && DateTime.now().isBefore(course.end)) || (DateTime.now().isBefore(course.start) && DateTime.now().isBefore(course.end)));
            return _StudentNextCursesCard(course);
          }
          return Container();
        }
    );
  }

  _StudentNextCursesCard(CourseModel course) {
    String place = course.location.replaceAll("[", '').replaceAll("]", '');
    //DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-4, 11, 35);

    int diffDay = 0;
    Duration diffTime = Duration(hours: 0);
    String diff;
    DateTime.now().day != course.start.day ?
    diffDay = course.start.day-DateTime.now().day :
    diffTime = course.start.difference(DateTime.now());
    diffDay < -7 ? diff = "Dans " + (diffDay.abs()/7).toString().split('.').first + " semaines" :
    diffDay == 1 ? diff = "Demain à " + DateFormat("HH:mm","fr_FR").format(course.start) :
    diffDay > 1 ? diff = DateFormat("EEE à HH:mm","fr_FR").format(course.start) :
    diffTime.inHours >= 1 ? diff = "Dans " + diffTime.inHours.toString() + "h" + (diffTime.inMinutes%60).toString() + "min" :
    diff = "Dans " + (diffTime.inMinutes%60).toString() + "min" + diffDay.toString();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Stack(
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 120),
                    child: Text(course.type + ' : ' + course.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),),
                  ),
                  SizedBox(height: 10),
                  Text('Enseigné par ' + course.teachers.replaceAll("[", '').replaceAll("]", ''), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),),
                  SizedBox(height: 5),
                  Text('De ' + DateFormat("HH:mm","fr_FR").format(course.start) + ' à ' + DateFormat("HH:mm","fr_FR").format(course.end), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 10,
              child: Chip(label: Container(padding: EdgeInsets.symmetric(horizontal: 2), child : Center(child: Text(diff, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,)),)), padding: EdgeInsets.all(0), ),
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

  _StudentClub() {
    final List<int> idClub = [100, 106, 1, 2, 3];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 80,
      //child:
      child: StreamBuilder(
          stream: clubsBloc.allClubs,
          builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
            return snapshot.hasData ?
            ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: idClub.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: CircleAvatar(
                      backgroundColor: Colors.blueGrey.withOpacity(0.2),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data.firstWhere((club) => club.idClubRef == idClub[index]).urlPhoto),
                        backgroundColor: Colors.white,
                        radius: 35,
                      ),
                      radius: 38,
                    ),
                  );
                }
            ) : Container();
          }
      ),
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
