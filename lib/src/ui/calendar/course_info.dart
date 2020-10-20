//When user click on an event on the agenda
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/custom_item_with_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CourseInfoPage extends StatefulWidget {

  final CourseModel course;
  CourseInfoPage({this.course});

  @override
  State<StatefulWidget> createState() {
    return EventInfoState();

  }
}

class EventInfoState extends State<CourseInfoPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, appState, child) {
          return  Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10.0,
            child: dialogContent(context),
          );
        }
    );
  }


  String day(DateTime date) {
    String d = DateFormat("EEEE", "fr_FR").format(date);
    d = d[0].toUpperCase() + d.substring(1);
    String n = DateFormat(" dd ", "fr_FR").format(date);
    String m = DateFormat("MMMM", "fr_FR").format(date);
    m = m[0].toUpperCase() + m.substring(1);
    return d + n + m;
  }

  String hour(DateTime date) {
    return DateFormat("HH:mm", "fr_FR").format(date);
  }

  dialogContent(BuildContext context) {
    return Wrap(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.topCenter,
              child: Text(day(widget.course.start),
                style: TextStyle(
                    color: MyTheme.colorTheme(context, colorLight: Colors.black),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),
              )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(hour(widget.course.start), style: TextStyle(
                              color: MyTheme.colorTheme(context, colorLight: Colors.black), fontSize: 20, fontWeight: FontWeight.bold),),
                          Text(hour(widget.course.end), style: TextStyle(
                              color: MyTheme.colorTheme(context, colorLight: Colors.black), fontSize: 20, fontWeight: FontWeight.bold),)
                        ]),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                getTitle(),
                                style: TextStyle(color: MyTheme.colorTheme(context, colorLight: Colors.black), fontSize: 25, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                minFontSize: 15,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                              getTeacher(),
                            ]
                        ),
                      ),
                    ),
                  ]
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Divider(
              color: MyTheme.colorTheme(context, colorLight: Colors.black, colorDark: Colors.grey),
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Chip(
                    label: Text(widget.course.type.toUpperCase(), style: TextStyle(color: MyTheme.colorTheme(context, colorLight: Colors.black), fontWeight: FontWeight.w500)),
                    backgroundColor: widget.course.color.withOpacity(0.5),
                  ),
                  //CustomItemWithIcon(Icons.place, getPlace()),
                  getPlace(),
                  CustomItemWithIcon(Icons.timer, getTime()),
                  CustomItemWithIcon(Icons.class_, widget.course.unite),
                  CustomItemWithIcon(Icons.group, widget.course.group),
                ],
              )
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(10),
            child: Text(update(), style: TextStyle(fontSize: 10, color: MyTheme.colorTheme(context, colorLight: Colors.grey), fontStyle: FontStyle.italic)),
          ),
        ]
    );
  }

  CustomItemWithIcon getPlace() {
    String place = widget.course.location.replaceAll("[", "").replaceAll("]", "");
    if(place == "Classe virtuelle") return CustomItemWithIcon(Icons.home, place);
    else return CustomItemWithIcon(Icons.place, place);
  }

  update() {
    return "Mis à jour le " + DateFormat("dd MMM à HH:mm", "fr_FR").format(widget.course.updated);
  }

  getTime() {
    String h = widget.course.end.difference(widget.course.start).inHours.toString()+"h";
    if(widget.course.end.difference(widget.course.start).inMinutes%60 != 0)
      h += (widget.course.end.difference(widget.course.start).inMinutes%60).toString();
    return h;
  }

  getTitle() {
    return widget.course.title.split(" - ").first;
  }

  getTeacher() {
    if(widget.course.teachers != "[]")
      return Row(
          children: <Widget>[
            Text("Enseigné par ", style: TextStyle(color: MyTheme.colorTheme(context, colorLight: Colors.black))),
            Expanded(
              child: AutoSizeText(
                widget.course.teachers.toString().substring(1, widget.course.teachers.toString().length-1),
                style: TextStyle(color: MyTheme.colorTheme(context, colorLight: Colors.black), fontWeight: FontWeight.bold),
                maxLines: 1,
                minFontSize: 8,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]
      );
    return Container();
  }
}