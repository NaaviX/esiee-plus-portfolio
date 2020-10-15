import 'dart:convert';

import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/course_event.dart';
import 'package:bde_esiee_mobile/src/blocs/courses_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/event_event.dart';
import 'package:bde_esiee_mobile/src/blocs/event_state.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/resources/event_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/event_repository.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_info.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/ScrollPhy.dart';
import 'package:bde_esiee_mobile/src/ui/event/event_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  @override
  void initState() {
    if(Base.thisUser != null) {
      BlocProvider.of<CoursesBloc>(context)
          .add(CoursesRequested());
    }
    BlocProvider.of<EventsBloc>(context)
        .add(EventsRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 75),
              child: SingleChildScrollView(
                //padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Base.allClubs != null && Base.thisUser!=null ? _component('Mes Clubs', 0, Base.allClubs.where((element) => element.students.contains(Base.thisUser)).toList()) : Container(),
                    Base.thisUser!=null ? _component('Mon Prochain Cours', 1) : Container(),
                    _component('Top Events', 2),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: _links(),
            ),
          ],
        ));
  }

  _component(String title, int type, [List<ClubModel> clubs]) {
    return (type == 0 && clubs.isNotEmpty) || type != 0 ?
    Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w900),
              ),
            ),
            type == 0
                ? _studentClub(clubs)
                : type == 1
                ? _studentNextCurses()
                : type == 2 ? _topEvents() : Container()
          ],
        )
    ) : Container() ;
  }

  _topEvents() {
    List<EventModel> tops = List();
    return Container(
        margin: EdgeInsets.only(top: 10),
        //padding: EdgeInsets.symmetric(vertical: 10,),
        child: BlocBuilder<EventsBloc, EventState>(
            builder: (context, state) {
              if (state is EventsInitial) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is EventsLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is EventsLoadSuccess) {
                final events = state.events;

                Base.allEvents = events.toList();

                events.removeWhere((event) =>
                !event.enable || event.endDate.isBefore(DateTime.now()));
                if (events.isEmpty)
                  return Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "Aucun évenement à venir... 😔",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ));
                tops.addAll(events.where((event) => event.enabledStratif));
                tops.isEmpty ? tops.add(events.last) : tops = tops;
                return _topEventsList(events);
              }
              if (state is EventsLoadFailure) {
                return Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Container();
            })
    );
  }

  _topEventsList(List<EventModel> tops) {
    return Container(
      height: 200,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: ListView.builder(
          physics: CustomScrollPhysics(itemDimension: MediaQuery.of(context).size.width/1.25 + 28),
          scrollDirection: Axis.horizontal,
          itemCount: tops.length,
          controller: PageController(viewportFraction: 0.8),
          itemBuilder: (context, i) {
            final EventRepository eventRepository = EventRepository(
              eventApiProvider: EventApiProvider(
                client: Client(),
              ),
            );
            EventsBloc bloc = EventsBloc(eventRepository: eventRepository);
            return GestureDetector(
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BlocProvider(
                                create: (BuildContext context) => bloc,
                                child: EventInfoPage(
                                  tops[i],
                                  Base.allClubs.firstWhere((club) =>
                                  club.idClubRef ==
                                      tops[i].idClubRef),
                                  eventsBloc: bloc,))), //FairPayClubManager(club)),
                  ),
              child: Container(
                margin: i == 0
                    ? const EdgeInsets.only(left: 15, right: 15)
                    : const EdgeInsets.only(right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0))
                        ),
                        child: Container(
                          height: 130,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.25,
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(
                                tops[i].backgroundUrl,
                              ),
                            ),
                          ),
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0))
                          ),
                          color: MyTheme.SelectedColor,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(DateFormat("MMM", "fr_FR").format(
                                    tops[i].startDate).toUpperCase().replaceAll(
                                    ".", ''), style: TextStyle(fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),),
                                Text(tops[i].startDate.day.toString(),
                                  style: TextStyle(fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.25 - 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(tops[i].name, maxLines: 2,
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),),
                              AutoSizeText("Organisé par " + Base.allClubs
                                  .firstWhere((club) =>
                              club.idClubRef == tops[i].idClubRef)
                                  .name, maxLines: 2,
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800),),
                              Text(DateFormat("HH:mm", "fr_FR").format(
                                  tops[i].startDate) + _hours(tops[i]),
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  _hours(EventModel event) {
    return event.startDate != event.endDate
        ? " à " + DateFormat("HH:mm", "fr_FR").format(event.endDate)
        : '';
  }

  Future<String> getLocalCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String localEvents = prefs.getString('coursesJson');
    return localEvents;
  }

  _studentNextCurses() {
    return TimerBuilder.periodic(Duration(minutes: 1), builder: (context) {
      return FutureBuilder(
          future: getLocalCourses(),
          builder: (BuildContext context, AsyncSnapshot<String> eventsJson) {
            if (eventsJson.hasData) {
              dynamic jsonData = jsonDecode(eventsJson.data);
              List<CourseModel> snapshot =
              CourseModel.allCoursesFromJson(jsonData).toList();
              DateTime now = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute - 30);
              CourseModel course = snapshot.firstWhere((course) =>
              now.isBefore(course.start) && now.isBefore(course.end));
              return _studentNextCursesCard(course);
            }
            return Container();
          });
    });
  }

  _studentNextCursesCard(CourseModel course) {
    String place = course.location.replaceAll("[", '').replaceAll("]", '');

    int diffDay = 0;
    Duration diffTime = Duration(hours: 0);
    String diff;
    DateTime.now().day != course.start.day
        ? diffDay = course.start.day - DateTime.now().day
        : diffTime = course.start.difference(DateTime.now());
    course.start.isBefore(DateTime.now()) || course.start == DateTime.now()
        ? diff = "En cours"
        : diffDay < -7
        ? diff = "Dans " +
        (diffDay.abs() / 7).toString().split('.').first +
        " semaines"
        : diffDay == 1
        ? diff = "Demain à " +
        DateFormat("HH:mm", "fr_FR").format(course.start)
        : diffDay > 1
        ? diff =
        DateFormat("EEE à HH:mm", "fr_FR").format(course.start)
        : diffTime.inHours >= 1
        ? diff = "Dans " +
        diffTime.inHours.toString() +
        "h" +
        (diffTime.inMinutes % 60).toString() +
        "min"
        : diff = "Dans " +
        (diffTime.inMinutes % 60).toString() +
        "min";

    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        //color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.8),
                      Colors.blueAccent
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0)),
              constraints: BoxConstraints(minHeight: 150.0),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 125),
                    child: Text(
                      course.type + ' : ' + course.title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Text(
                        'Enseigné par ',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      Text(
                        course.teachers.replaceAll("[", '').replaceAll("]", ''),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'De ' +
                        DateFormat("HH:mm", "fr_FR").format(course.start) +
                        ' à ' +
                        DateFormat("HH:mm", "fr_FR").format(course.end),
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    course.group.replaceAll("[", '').replaceAll("]", ''),
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 10,
              child: Chip(
                backgroundColor: MyTheme.LightBackground,
                label: Container(padding: EdgeInsets.symmetric(horizontal: 2),
                    child : Center(
                      child: Text(
                          diff, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: MyTheme.PrimaryColorLight)
                      ),
                    )
                ),
                padding: EdgeInsets.all(0),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: place == 'Classe virtuelle'
                  ? Icon(
                Icons.home,
                color: Colors.white,
                size: 25,
              )
                  : Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 15,
                  ),
                  Text(
                    place,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _studentClub(List<ClubModel> clubs) {
    return Container(
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 80,
        //child:
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: clubs.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClubInfoPage(
                            club: clubs[index],
                          )),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Hero(
                      tag: 'logoClub' + clubs[index].idClubRef.toString(),
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey.withOpacity(0.2),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(clubs[index].urlPhoto),
                          backgroundColor: Colors.white,
                          radius: 35,
                        ),
                        radius: 38,
                      ),
                    ),
                  ));
            }));
  }

  _links() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      //height: 62,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _homeStudentUsefulLinks("Webaurion", "https://webaurion.esiee.fr/",
              "https://media-exp1.licdn.com/dms/image/C4D0BAQFbOzrZBcQXgA/company-logo_200_200/0?e=2159024400&v=beta&t=TzGOdwYwDfAOQ51SmYuSV6XaC8-uHv39pj-xLw3H2y0"),
          _homeStudentUsefulLinks("Blackboard", "https://esiee.blackboard.com/",
              "https://www.osa.fu-berlin.de/studieneinstieg/en/_media/grafiken/BlackboardMobileLearnAppIcon.png"),
          _homeStudentUsefulLinks("ICampus", "https://icampus.esiee.fr/",
              "https://enovationsolutions.fr/wp-content/uploads/2018/02/moodle-logo-300x225.png"),
          _homeStudentUsefulLinks("Intra", "https://intra.esiee.fr/",
              "https://www.esiee.fr/sites/all/themes/custom/esiee_theme/logo.png"),
        ],
      ),
    );
  }

  _homeStudentUsefulLinks(
      String nom,
      String site,
      String image,
      ) {
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
                decoration: BoxDecoration(
                  color: MyTheme.LightBackground,
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: new NetworkImage(image),
                  ),
                )),
            Text(
              nom,
              style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700),
            ),
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
