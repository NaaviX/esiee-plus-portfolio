import 'package:bde_esiee_mobile/src/blocs/club_event.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_add_member.dart';
import 'package:bde_esiee_mobile/src/ui/student/student_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../App.dart';

class ClubMemberManager extends StatefulWidget {

  final StudentsBloc studentsBloc;
  final ClubsBloc clubsBloc;

  ClubMemberManager({Key key, @required this.studentsBloc, @required this.clubsBloc})
      : assert(studentsBloc != null && clubsBloc != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClubMemberManagerState();
  }
}

class ClubMemberManagerState extends State<ClubMemberManager> {
  final email = TextEditingController();

  final log = Logger('clubmanager');

  FocusScopeNode currentFocus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestion des membres"),
        ),
        body: GestureDetector(
            onTap: () {
              currentFocus = FocusScope.of(context);

              currentFocus.unfocus();
            },
            child: Column(
              children: <Widget>[

    BlocProvider<StudentsBloc>.value(value: widget.studentsBloc,
        child: BlocProvider<ClubsBloc>.value(value: widget.clubsBloc,
            child: ClubAddMember(this))),
                Expanded(
                    child: ListView.builder(
                  itemCount: Base.thisClub.students.length,
                  itemBuilder: (BuildContext context, int index) {
                    StudentModel student =
                    Base.thisClub.students.elementAt(index);
                    return ListTile(
                        title: Text(
                          student.firstname + " " + student.lastname,
                        ),
                        trailing: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Base.thisClub.students.remove(student);
                            BlocProvider.of<ClubsBloc>(context)
                                .add(ClubToBeSaved(club: Base.thisClub));
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

              ],
            )));
  }
}
