
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ClubAddMember extends StatefulWidget {
  final ClubModel thisClub;
  const ClubAddMember(this.thisClub);

  @override
  State<StatefulWidget> createState() {
    return ClubAddMemberState();
  }

}
class ClubAddMemberState extends State<ClubAddMember> {
  StudentsBloc studentsBloc = StudentsBloc();

  final log = Logger('clubaddmember');

  final _formKey = GlobalKey<FormState>();

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
    return Scaffold(
        appBar: AppBar(
        title: Text("Gestion des membres"),
    ),
    body: StreamBuilder(
      stream: studentsBloc.allStudents,
      builder: (context, AsyncSnapshot<List<StudentModel>> snapshot) {
        if (snapshot.hasData) {
          log.fine(snapshot.data);
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column()/*SearchWidget(
                        dataList: snapshot.data,
                        hideSearchBoxWhenItemSelected: false,
                        listContainerHeight: MediaQuery.of(context).size.height / 4,
                        queryBuilder: (String query, List<StudentModel> list) {
                          return list.where((StudentModel student) => student.mailEsiee.toLowerCase().contains(query.toLowerCase())).toList();
                        },
                        popupListItemBuilder: (StudentModel item) {
                                          return Container(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              item.mailEsiee,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          );
                                        },
                                        selectedItemBuilder: (StudentModel selectedItem, VoidCallback deleteSelectedItem) {

                                          return; //SelectedItemWidget(selectedItem, deleteSelectedItem);
                                        },
                                        // widget customization
                                        //noItemsFoundWidget: NoItemsFound(),
                                        textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                                          return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                          );
                                        },
                      )*/
                    //CustomTextFormField("Eleve", "adresse email de l\'élève", Icons.email, email)
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
        } else if (snapshot.hasError) {
          log.fine(snapshot.data);
          return Text(snapshot.error.toString());
        }
        log.fine(snapshot.data);
        return Center(child: CircularProgressIndicator());
      },
    ));
  }

}