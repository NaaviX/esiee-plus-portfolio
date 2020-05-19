import 'package:bde_esiee_mobile/src/models/grades_model.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final log = Logger('GradesUnit_List');

saveGrade(GradesModel grades) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String gradesUnitID = grades.id.toString();
  prefs.setString("Grade_ID", gradesUnitID);
  log.log(Level.INFO, 'saved $gradesUnitID locally.');
}

saveUnits(String grades) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("GradeUnits_ID", grades);
  log.log(Level.INFO, 'saved $grades locally.');
}

Future<String> getGradeID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // ignore: non_constant_identifier_names
  String GradesUnitID = prefs.getString('Grade_ID');
  return GradesUnitID;
}

Future<String> getGradeUnitsID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String gradesUnitID = prefs.getString('GradeUnits_ID');
  return gradesUnitID;
}

removeValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.remove("Grade_ID");
  prefs.remove("GradeUnits_ID");
}