import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:search_widget/search_widget.dart';

import '../../App.dart';
import 'club_member_manager.dart';

class ClubAddMember extends StatefulWidget {
  final ClubMemberManagerState parent;

  const ClubAddMember(this.parent);

  @override
  State<StatefulWidget> createState() {
    return ClubAddMemberState();
  }
}

class ClubAddMemberState extends State<ClubAddMember> {
  StudentsBloc studentsBloc = StudentsBloc();

  ClubsBloc clubsBloc = ClubsBloc();

  final log = Logger('clubaddmember');

  final _formKey = GlobalKey<FormState>();

  StudentModel studentSelected;

  FocusNode focus;


  @override
  void initState() {
    super.initState();
    studentsBloc.fetchAllStudents();
  }

  @override
  void dispose() {
    studentsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: studentsBloc.allStudents,
          builder: (context, AsyncSnapshot<List<StudentModel>> snapshot) {
            if (snapshot.hasData) {
              for(StudentModel student in Base.thisClub.students) {
                snapshot.data.removeWhere((element) => element.idStudent == student.idStudent);
              }
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SearchWidget<StudentModel>(

                          dataList: snapshot.data,
                          hideSearchBoxWhenItemSelected: false,
                          listContainerHeight:
                              MediaQuery.of(context).size.height / 4,
                          queryBuilder:
                              (String query, List<StudentModel> list) {

                            return list
                                .where((StudentModel student) => (
                                student
                                        .firstname
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase()) ||
                                    student.lastname
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase()) ||
                                    (student.firstname+" "+student.lastname)
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase())))
                                .toList();
                          },
                          popupListItemBuilder: (StudentModel item) {
                            return _popupListItemBuilder(item);
                          },
                          selectedItemBuilder: (StudentModel selectedItem,
                              VoidCallback addSelectedItem) {
                            return;
                          },
                          // widget customization
                          noItemsFoundWidget: _noItemsFoundWidget(),
                          textFieldBuilder: (TextEditingController controller,
                              FocusNode focusNode) {
                            focus = focusNode;
                            return CustomTextFormField("Ajouter un membre", "Prenom ou nom de l'élève", Icons.search, controller, focusNode: focusNode);

                          },
                        )
                        ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        );
  }

  Widget _popupListItemBuilder(StudentModel item) {
    if(!Base.thisClub.students.contains(item)) {
      return ListTile(
          subtitle: Text(
            item.firstname + " " + item.lastname + "\n" +
                item.mailEsiee.toString(),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.green,),
            onPressed: () {
              if(!item.isContributor) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text("Erreur : cet élève n'est pas cotisant au BDE"),
                  backgroundColor: Colors.red,
                ));
              } else {
                clubsBloc.addStudentToClub(item, Base.thisClub);
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text("Membre ajouté !"),
                  backgroundColor: Colors.green,
                ));
                widget.parent.setState(() {

                });
              }

              focus.unfocus();


            },)
      );
    }
    return Column();
  }

  Widget _noItemsFoundWidget() {
    return Text("Aucun étudiant trouvé");
  }
}
