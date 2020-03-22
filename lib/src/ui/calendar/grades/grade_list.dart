import 'package:bde_esiee_mobile/src/models/gradesUnit_model.dart';
import 'package:bde_esiee_mobile/src/models/grades_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/grades_utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../App.dart';
import '../../../blocs/grades_bloc.dart';
import 'gradeUnits_list.dart';

class GradesList extends StatelessWidget {
  final log = Logger('Grades_List');
  final bloc = GradesBloc();

  @override
  Widget build(BuildContext context){
    bloc.fetchAllGrades();
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.allGrades,
        builder: (context, AsyncSnapshot<List<GradesModel>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          removeValues();
          Navigator.push( context, MaterialPageRoute(builder: (context) => App()));
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget buildList(AsyncSnapshot<List<GradesModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
              onTap: () {
                saveGrade(snapshot.data[index]);
                Navigator.push(context, MaterialPageRoute(builder: (context) => GradeUnitsList(grades: snapshot.data[index] )));//GradeUnitsCheckList( unitsState: {GradesUnitModel(name: 'Groupe 1', id: 01): false, GradesUnitModel(name: 'Groupe 2', id: 02): false} )));
              },
              child: Padding(
                  padding: EdgeInsets.only(top:4.0,bottom: 4.0,left: 10.0,right: 10.0),
                  child: Container(
                      child : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child : Padding(
                            child:
                            Text(
                                snapshot.data[index].name,
                                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 18.0)),
                            padding: EdgeInsets.all(20.0),
                          )
                      ),
                      decoration : BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(2.0, 4.0)
                        ),
                      ]
                      )
                  )
              )
          );
        }
    );
  }

}



