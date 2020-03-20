//When user click on an event on the agenda
import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../custom_widgets/Hyperlink';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title)
      ),
        body: Text(widget.course.location)
    );
  }
}