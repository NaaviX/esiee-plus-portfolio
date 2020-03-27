import 'package:bde_esiee_mobile/src/models/gradesUnit_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/gradesunits_bloc.dart';
import 'package:bde_esiee_mobile/src/models/grades_model.dart';

class GradesUnitList extends StatefulWidget {
  final GradesModel grades;
  GradesUnitList({this.grades});
  @override
  State<StatefulWidget> createState() {
    return GradesUnitListState(grades : this.grades);
  }
}

class GradesUnitListState extends State<GradesUnitList> {
  // ignore: non_constant_identifier_names
  GradesModel grades;
  GradesUnitListState({this.grades});
  // ignore: non_constant_identifier_names
  Map<String, bool> GradesUnits = {};
  final bloc = GradesUnitBloc();

  @override
  void initState() {
    super.initState();
    saveGradesUnits();
    bloc.fetchAllGradesUnit(this.grades.id.toString());
    bloc.allGradesUnit;
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  final log = Logger('GradesUnit_List');

  /*@override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('CheckboxListTile demo')),
      body: new ListView(
        children: GradesUnits.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: GradesUnits[key],
            onChanged: (bool value) {
              setState(() {
                GradesUnits[key] = value;
              });
            },
          );
        }).toList(),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final bloc = GradesUnitBloc();
    bloc.fetchAllGradesUnit(this.grades.id.toString());

    return Scaffold(
        appBar: AppBar(
          title: Text(this.grades.name),
        ),
        body: StreamBuilder(
          stream: bloc.allGradesUnit,
          builder: (context, AsyncSnapshot<List<GradesUnitModel>> snapshot) {
            if (snapshot.hasData) {
              GradesUnits = getGradeUnitBoxState(snapshot.data);
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  Widget buildList(AsyncSnapshot<List<GradesUnitModel>> snapshot) {

    return new Scaffold(
      body: new ListView(
        children: GradesUnits.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: GradesUnits[key],
            onChanged: (bool value) {
              setState(() {
                GradesUnits[key] = value;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  saveGradesUnits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: non_constant_identifier_names
    String GradesUnitID = this.grades.id.toString();
    prefs.setString("GradesUnit_ID", GradesUnitID);
    log.log(Level.INFO, 'saved $GradesUnitID locally.');
  }

  Future<String> getGradesUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: non_constant_identifier_names
    String GradesUnitID = prefs.getString('GradesUnit_ID');
    return GradesUnitID;
  }

  getGradeUnitBoxState(List<GradesUnitModel> gradeUnitData) {
    Map<String, bool> gradeUnits = {};
    gradeUnitData.forEach(
            (element) => gradeUnits.putIfAbsent(element.name, () => false)
    );
    return gradeUnits;
  }
}


