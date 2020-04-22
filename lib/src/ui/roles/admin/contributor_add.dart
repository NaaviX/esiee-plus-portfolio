import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:bde_esiee_mobile/src/ui/roles/admin/contributor_manager.dart';
import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';

// ignore: must_be_immutable
class ContributorAdd extends StatefulWidget {
  ContributorManagerState parent;
  List<StudentModel> allStudentsExceptContributors;

  ContributorAdd(this.parent, this.allStudentsExceptContributors);

  @override
  State<StatefulWidget> createState() {
    return ContributorAddState();
  }
}

class ContributorAddState extends State<ContributorAdd> {

  final _formKey = GlobalKey<FormState>();


  StudentsBloc studentsBloc = StudentsBloc();

  @override
  void dispose() {
    super.dispose();
    studentsBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: SearchWidget<StudentModel>(

                dataList: widget.allStudentsExceptContributors,
                hideSearchBoxWhenItemSelected: false,
                listContainerHeight:
                MediaQuery
                    .of(context)
                    .size
                    .height / 4,
                queryBuilder:
                    (String query, List<StudentModel> list) {
                  return list
                      .where((StudentModel student) =>
                  (
                      student
                          .firstname
                          .toLowerCase()
                          .startsWith(query.toLowerCase()) ||
                          student.lastname
                              .toLowerCase()
                              .startsWith(query.toLowerCase()) ||
                          (student.firstname + " " + student.lastname)
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
                  widget.parent.currentFocus = focusNode;
                  return CustomTextFormField(
                      "Ajouter un membre", "Prenom ou nom de l'élève",
                      Icons.person_add, controller, focusNode: focusNode);
                },
              )
          ),
        ],
      ),
    );
  }

  Widget _popupListItemBuilder(StudentModel item) {
    if (!item.isContributor) {
      return ListTile(
          subtitle: Text(
            item.firstname + " " + item.lastname + "\n" +
                item.mailEsiee.toString(),
          ),
          trailing: Builder(
              builder: (context) => IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.green,),
            onPressed: () {
              widget.parent.addStudentToContributor(item);
              widget.parent.currentFocus.unfocus();
            },))
      );
    }
    return Column();
  }

  Widget _noItemsFoundWidget() {
    return Text("Aucun étudiant trouvé");
  }
}
