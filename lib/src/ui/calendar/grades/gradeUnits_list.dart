import 'package:bde_esiee_mobile/src/models/gradesUnit_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/grades_utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../../../App.dart';
import '../../../blocs/gradesunits_bloc.dart';
import 'package:bde_esiee_mobile/src/models/grades_model.dart';

class GradeUnitsList extends StatefulWidget {
  final GradesModel grades;
  GradeUnitsList({this.grades});

  @override
  State<StatefulWidget> createState() {
    return GradeUnitsListState(grades : this.grades);
  }
}

class GradeUnitsListState extends State<GradeUnitsList> {
  GradesModel grades;
  GradeUnitsListState({this.grades});

  final bloc = GradesUnitBloc();
  Map<GradesUnitModel, bool> unitsState = {};

  @override
  void initState() {
    super.initState();
    bloc.fetchAllGradesUnit(this.grades.id.toString());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: bloc.allGradesUnit,
          builder: (context, AsyncSnapshot<List<GradesUnitModel>> snapshot) {
            if (snapshot.hasData) {
              unitsState = getUnitsState(snapshot.data);
              return GradeUnitsCheckList( unitsState: unitsState);//{ GradesUnitModel(name: 'Groupe 1', id: 01): false, GradesUnitModel(name: 'Groupe 2', id: 02): false} );//buildList(snapshot);
            }
            else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }
    );
  }

  getUnitsState(List<GradesUnitModel> gradeUnitData) {
    Map<GradesUnitModel, bool> gradeUnits = {};
    gradeUnitData.forEach(
            (unit) => gradeUnits.putIfAbsent(unit, () => false)
    );
    return gradeUnits;
  }
}

class GradeUnitsCheckList extends StatefulWidget{
  final Map<GradesUnitModel, bool> unitsState;
  GradeUnitsCheckList({this.unitsState});

  @override
  GradeUnitsCheckListState createState() {
    return new GradeUnitsCheckListState(unitsState: unitsState);
  }

}

class GradeUnitsCheckListState extends State<GradeUnitsCheckList>{
  final Map<GradesUnitModel, bool> unitsState;
  GradeUnitsCheckListState({this.unitsState});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('CheckboxListTile demo')),
      body: new ListView(
        children: unitsState.keys.map((GradesUnitModel unit) {
          return new CheckboxListTile(
            title: new Text(unit.name),
            value: unitsState[unit],
            onChanged: (bool value) {
              setState(() {
                log.log(Level.ALL, unit.id);
                unitsState[unit] = value;
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveUnitsState();
          Navigator.push( context, MaterialPageRoute(builder: (context) => App()));
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
    );
  }

  saveUnitsState(){
    List<String> unitsIdList = [];
    this.unitsState.forEach((unit, value) {
      if(value) unitsIdList.add(unit.id.toString());
    });
    String unitsID = unitsIdList.join("-");
    saveUnits(unitsID);
  }

}
