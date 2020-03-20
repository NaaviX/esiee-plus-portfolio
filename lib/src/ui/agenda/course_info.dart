//When user click on an event on the agenda
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
              child: Text(day(widget.course.start),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
          ),
          Container(
              padding: EdgeInsets.all(15),
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
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.course.title, style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),),
                            Row(children: <Widget>[
                              Text("Enseigné par "),
                              Text(
                                  "NATOWICZ R.",
                                  style: TextStyle(fontWeight: FontWeight
                                      .bold)
                              )
                            ]
                            )
                          ]
                      ),
                    ),
                  ]
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Divider(
              color: Colors.black,
            ),
          ),
          Container(
          padding: EdgeInsets.only(left: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.course.type),
                CustomItemWithIcon(Icons.place, widget.course.location),
                CustomItemWithIcon(Icons.timer, widget.course.end.difference(widget.course.start).inHours.toString()+"h"),
                CustomItemWithIcon(Icons.class_, getUnit()),
                CustomItemWithIcon(Icons.group, getGroup()),
              ],
            )
          ),
        ]
    );
  }


  getGroup() {
    List<String> desc =  widget.course.description.split("\n");
    String unit = desc.removeLast();
    return desc.toString();
  }

  getUnit() {
    return widget.course.description.split("\n").last;
  }
}