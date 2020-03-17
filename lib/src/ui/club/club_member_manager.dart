import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_add_member.dart';
import 'package:bde_esiee_mobile/src/ui/club/student_info.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

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

  final ClubsBloc clubsBloc = ClubsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestion des membres"),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              currentFocus.unfocus();
            },
            child: Column(
              children: <Widget>[
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
                            clubsBloc.removeStudentFromClub(
                                student, widget.thisClub);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Membre supprimé"),
                              backgroundColor: Colors.green,
                            ));
                            setState(() {});
                            
                          },
                        ),
                        onTap: () {
                          showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return StudentDetail(student);
                              });
                        });
                  },
                )),
                Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: ClubAddMember(widget.thisClub, this),
                )
              ],
            )));
  }
}
