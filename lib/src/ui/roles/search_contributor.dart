import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:bde_esiee_mobile/src/ui/student/student_info.dart';
import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';

import 'contributor_verificator.dart';


class SearchContributor extends StatefulWidget {
  final ContributorVerificatorState parent;

  final List<StudentModel> students;

  SearchContributor(this.parent, {@required this.students});

  @override
  State<StatefulWidget> createState() {
    return SearchContributorState();
  }
}

class SearchContributorState extends State<SearchContributor> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (widget.students != null && widget.students.length != 0) {
      return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: SearchWidget<StudentModel>(
                  dataList: widget.students,
                  hideSearchBoxWhenItemSelected: false,
                  listContainerHeight:
                  MediaQuery
                      .of(context)
                      .size
                      .height / 4,
                  queryBuilder:
                      (String query, List<StudentModel> list) {
                    return list
                        .where((StudentModel students) =>
                    (
                        students
                            .firstname
                            .toLowerCase()
                            .startsWith(query.toLowerCase()) ||
                            students.lastname
                                .toLowerCase()
                                .startsWith(query.toLowerCase()) ||
                            (students.firstname + " " + students.lastname)
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
                        "Chercher", "Prenom ou nom du professeur",
                        Icons.search, controller,
                        focusNode: focusNode);
                  },
                )
            ),
          ],
        ),
      );
    }
    else
      return LinearProgressIndicator();
  }

  Widget _popupListItemBuilder(StudentModel item) {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: ListTile(
          subtitle:Text(
            item.firstname + " " + item.lastname + "\n" + item.mailEsiee.toString(),
          ),
          trailing: item.isContributor ? Icon(Icons.check_circle, size:20, color: Colors.green,) : null,
          onTap: () {
            showDialog<void>(
                context: context,
                barrierDismissible: true,
                // user must tap button!
                builder: (BuildContext context) {
                  return StudentDetail(item);
                }
            );
            widget.parent.currentFocus.unfocus();
          },
        )
    );
  }

  Widget _noItemsFoundWidget() {
    return Text("Aucun élève trouvé");
  }
}