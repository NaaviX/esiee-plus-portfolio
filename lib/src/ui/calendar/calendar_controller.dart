import 'package:bde_esiee_mobile/src/ui/calendar/grades/grades_utils.dart';
import 'package:flutter/cupertino.dart';

import 'calendar.dart';
import 'grades/grade_list.dart';

class CalendarController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getGradeUnitsID(),
        builder: (BuildContext context, AsyncSnapshot<String> gradeUnitsID){
          return gradeUnitsID.hasData ? Calendar(ids: gradeUnitsID.data) : GradesList();
        }
    );
  }



}