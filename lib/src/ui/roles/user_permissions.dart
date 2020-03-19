import 'package:bde_esiee_mobile/src/blocs/roles_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:bde_esiee_mobile/src/ui/roles/roles_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class UserPermissions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserPermissionsState();
  }
}

class UserPermissionsState extends State<UserPermissions> {
  StudentsBloc studentsBloc = StudentsBloc();
  RolesBloc rolesBloc = RolesBloc();

  final searchController = TextEditingController();

  List<RoleModel> allRoles;

  String filter = "";

  @override
  void initState() {
    super.initState();
    studentsBloc.fetchAllStudents();
    rolesBloc.fetchAllRoles();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    studentsBloc.dispose();
    searchController.dispose();
    rolesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Droits des utilisateurs"),
        ),
        body: StreamBuilder(
            stream: rolesBloc.allRoles,
            builder:
                (context, AsyncSnapshot<List<RoleModel>> roleSnapshot) {
              if (roleSnapshot.hasData) {
                allRoles = roleSnapshot.data;
                return StreamBuilder(
                    stream: studentsBloc.allStudents,
                    builder:
                        (context,
                        AsyncSnapshot<List<StudentModel>> studentSnapshot) {
                      if (studentSnapshot.hasData) {

                        return Column(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: CustomTextFormField(
                                  "Rechercher...",
                                  "Prenom ou nom de l'élève",
                                  Icons.search,
                                  searchController)),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: studentSnapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    filter = searchController.text;
                                    StudentModel student =
                                    studentSnapshot.data[index];
                                    return filter == null || filter == ""
                                        ? _studentTile(student)
                                        : (student.firstname
                                        .toLowerCase()
                                        .startsWith(
                                        filter.toLowerCase()) ||
                                        student.lastname
                                            .toLowerCase()
                                            .startsWith(
                                            filter.toLowerCase()) ||
                                        (student.firstname +
                                            " " +
                                            student.lastname)
                                            .toLowerCase()
                                            .startsWith(
                                            filter.toLowerCase()))
                                        ? _studentTile(student)
                                        : new Container();
                                  }))
                        ]);
                      } else if (roleSnapshot.hasError) {
                        return Text(roleSnapshot.error.toString());
                      }
                      return Center(child: CircularProgressIndicator());
                    });
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  ListTile _studentTile(StudentModel student) {
    List<RoleModel> currentRoles = List.from(student.roles);
    return new ListTile(
      subtitle: Text(
        student.firstname +
            " " +
            student.lastname +
            "\n" +
            student.mailEsiee.toString(),
      ),
      onTap: () {
        showDialog<void>(
            context: context,
            barrierDismissible: true,
            // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(student.firstname + " " + student.lastname),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(

                          child: ListBody(

                            children: <Widget>[
                              Divider(
                                color: Colors.black,
                              ),
                              RolesDisplay(currentRoles),
                              SizedBox(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 3,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: allRoles.length,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      RoleModel thisRole = allRoles[index];
                                      return SwitchListTile(
                                        title: Text(
                                            describeEnum(thisRole.role)),
                                        value: currentRoles.contains(thisRole),
                                        onChanged: (bool value) {
                                          setState(() {
                                            if (value) {
                                              currentRoles.add(thisRole);
                                            } else {
                                              currentRoles.removeWhere((
                                                  element) =>
                                              element == thisRole);
                                            }
                                          });
                                        },
                                      );
                                    }),
                              ),


                            ],
                          ));
                    }),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Enregistrer'),
                    onPressed: () {
                      student.roles = List.from(currentRoles);
                      studentsBloc.updateStudent(student);
                      setState(() {

                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Retour'),
                    onPressed: () {
                      currentRoles = List.from(student.roles);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
    );
  }
}