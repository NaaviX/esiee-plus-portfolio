import 'package:bde_esiee_mobile/src/models/grades_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../blocs/grades_bloc.dart';

class GradesList extends StatelessWidget {
  final log = Logger('Grades_List');

  @override
  Widget build(BuildContext context){
    bloc.fetchAllGrades();
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.allGrades,
        builder: (context, AsyncSnapshot<List<GradesModel>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      )
    );
  }

  Widget buildList(AsyncSnapshot<List<GradesModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
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
                )),
                decoration : BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(2.0, 4.0)
                  ),
                ])
            )
          );
        });
  }

}



