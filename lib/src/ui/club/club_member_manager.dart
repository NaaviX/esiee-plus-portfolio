import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_add_member.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:search_widget/search_widget.dart';

class ClubMemberManager extends StatefulWidget {
  final ClubModel thisClub;

  const ClubMemberManager(this.thisClub);

  @override
  State<StatefulWidget> createState() {
    return ClubMemberManagerState();
  }
}

class ClubMemberManagerState extends State<ClubMemberManager> {


  final email = TextEditingController();



  final log = Logger('clubmanager');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestion des membres"),
        ),
        body: Column(
          children: <Widget>[
             Padding(
                      padding: EdgeInsets.all(30.0),
                      child: RaisedButton(
                        child: Text("Ajouter un membre",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                        onPressed: () {

                        },
                    )),
            Expanded(
                child: ListView.builder(
                    itemCount: widget.thisClub.students.length,
                    itemBuilder: (BuildContext context, int index) {
                      StudentModel student =
                          widget.thisClub.students.elementAt(index);
                      return ListTile(
                        title: Text(
                          student.firstname + " " + student.lastname,
                        ),
                        trailing: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            //bloc.removeStudentFromClub(student);
                          },
                        ),
                      );
                    }))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClubAddMember(widget.thisClub)),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue
        ));
  }
}
