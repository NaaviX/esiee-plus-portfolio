import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_add_member.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';

class ClubMemberManager extends StatefulWidget {
  final ClubModel thisClub;

  const ClubMemberManager(this.thisClub);

  @override
  State<StatefulWidget> createState() {
    return ClubMemberManagerState();
  }
}

class ClubMemberManagerState extends State<ClubMemberManager> {
  ClubsBloc bloc = ClubsBloc();

  final email = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CustomTextFormField("Eleve", "adresse email de l\'élève", Icons.email, email)
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                            child: Text("Ajouter"),
                                            onPressed: () {
                                              if (_formKey.currentState.validate()) {
                                                _formKey.currentState.save();
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
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
        ));
  }
}
