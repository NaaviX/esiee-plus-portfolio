import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_info.dart';
import 'package:bde_esiee_mobile/src/ui/prof/units_list.dart';
import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';

// ignore: must_be_immutable
class SearchProf extends StatefulWidget {
  UnitsListState parent;

  SearchProf(this.parent);

  @override
  State<StatefulWidget> createState() {
    return SearchProfState();
  }
}

class SearchProfState extends State<SearchProf> {

  final _formKey = GlobalKey<FormState>();

  ProfsBloc profs = ProfsBloc();

  @override
  void initState() {
    profs.fetchAllProfs();
    super.initState();
  }

  @override
  void dispose() {
    profs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: profs.allProfs,
        builder: (context, AsyncSnapshot<List<ProfModel>> snapshot) {
          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SearchWidget<ProfModel>(

                        dataList: snapshot.data,
                        hideSearchBoxWhenItemSelected: false,
                        listContainerHeight:
                        MediaQuery
                            .of(context)
                            .size
                            .height / 4,
                        queryBuilder:
                            (String query, List<ProfModel> list) {
                          return list
                              .where((ProfModel student) =>
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
                        popupListItemBuilder: (ProfModel item) {
                          return _popupListItemBuilder(item);
                        },
                        selectedItemBuilder: (ProfModel selectedItem,
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
            return Container();
        }
    );
  }

  Widget _popupListItemBuilder(ProfModel item) {
    return ListTile(
      subtitle:Text(
            item.firstname + " " + item.lastname + "\n" + item.mailEsiee.toString(),
      ),
      trailing: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            item.office != "" ? Icon(Icons.place, size:20) : Container(width:20),
            Text(item.office),
          ],),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfInfoPage(prof : item)),
        );
        widget.parent.currentFocus.unfocus();
      },
    );
  }

  Widget _noItemsFoundWidget() {
    return Text("Aucun professeur trouvé");
  }
}
