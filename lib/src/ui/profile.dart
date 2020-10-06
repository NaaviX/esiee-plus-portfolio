import 'dart:convert';
import 'dart:math';

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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_widgets/ColorMean.dart';

class Profile extends StatefulWidget {

  final Color color;
  Profile(this.color);

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    print("build");

    ColorDetect c = ColorDetect(user.photoUrl);


    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1,0.9],
                colors: [widget.color,  widget.color ] )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Hero(
                tag: "photo",
                child:Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                    radius: 60,
                  ),
                )),
            //Text(user.displayName, style: TextStyle(color: Colors.white, fontSize: 20)),
            //Text(user.email, style: TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ));
  }

  Color saturate(Color color, int value) {
    int max = color.blue;
  }

}
