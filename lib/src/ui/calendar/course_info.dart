//When user click on an event on the agenda
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/custom_item_with_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseInfoPage extends StatefulWidget {

  CourseModel course;
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(hour(widget.course.start), style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),),
                          Text(hour(widget.course.end), style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),)
                        ]),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                getTitle(),
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
              color: Colors.black,
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Chip(
                    label: Text(widget.course.type.toUpperCase()),
                    backgroundColor: widget.course.color.withOpacity(0.5),
                  ),
                  CustomItemWithIcon(Icons.place, widget.course.location),
                  CustomItemWithIcon(Icons.timer, getTime()),
                  CustomItemWithIcon(Icons.class_, getUnit()),
                  CustomItemWithIcon(Icons.group, getGroup()),
                ],
              )
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(10),
            child: Text(update(), style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic)),
          ),
        ]
    );
  }


  getGroup() {
    List<String> desc =  widget.course.description.split("\n");
    desc.removeLast();
    String unit = desc.toString();
    return unit.substring(1, unit.length-1);
  }

  getUnit() {
    return widget.course.description.split("\n").last;
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
            Text("Enseigné par "),
            Expanded(
              child: AutoSizeText(
                widget.course.teachers.toString().substring(1, widget.course.teachers.toString().length-1),
                style: TextStyle(fontWeight: FontWeight.bold),
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