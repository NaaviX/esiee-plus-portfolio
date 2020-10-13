import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/club_event.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/student_event.dart';
import 'package:bde_esiee_mobile/src/blocs/student_state.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/KeeAlivePage.dart';
import 'package:bde_esiee_mobile/src/ui/roles/roles_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPermissions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserPermissionsState();
  }
}

class UserPermissionsState extends State<UserPermissions> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.person,
                    ),
                    text: "Etudiants",
                  ),
                  Tab(icon: Icon(Icons.people), text: "Clubs"),
                ],
              ),
              title: Text("Droits des utilisateurs"),
            ),
            body: TabBarView(
              children: [
                KeepAlivePage(child: StudentPermissions()),
                KeepAlivePage(child: ClubPermissions()),
              ],
            )));
  }
}

class ClubPermissions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClubPermissionsState();
  }
}

class ClubPermissionsState extends State<ClubPermissions> {
  @override
  Widget build(BuildContext context) {
    if (Base.allClubs != null && Base.allClubs.length != 0) {
      return ListView.builder(
          itemCount: Base.allClubs.length,
          itemBuilder: (BuildContext context, int index) {
            ClubModel club = Base.allClubs[index];
            return _clubTile(club);
          });
    }
    return Center(child: CircularProgressIndicator());
  }

  ListTile _clubTile(ClubModel club) {
    List<RoleModel> currentRoles = List.from(club.roles);
    return new ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(club.urlPhoto),
        backgroundColor: Colors.white,
      ),
      title: Text(club.name),
      subtitle: Text(
        club.mail,
      ),
      onTap: () {
        showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(club.name),
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
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 3,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: Base.allRoles.length,
                            itemBuilder: (BuildContext context, int index) {
                              RoleModel thisRole = Base.allRoles[index];
                              return SwitchListTile(
                                title: Text(thisRole.toString()),
                                value: currentRoles.contains(thisRole),
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      currentRoles.add(thisRole);
                                    } else {
                                      currentRoles.removeWhere(
                                          (element) => element == thisRole);
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
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      club.roles = List.from(currentRoles);
                      BlocProvider.of<ClubsBloc>(context)
                          .add(ClubToBeSaved(club: club));
                      BlocProvider.of<ClubsBloc>(context).add(ClubsRequested());
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Retour'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      currentRoles = List.from(club.roles);
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

class StudentPermissions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentPermissionsState();
  }
}

class StudentPermissionsState extends State<StudentPermissions> {
  final searchController = TextEditingController();

  String filter = "";

  List<String> dropDownRoles;
  String selectedRole = "Admin";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentsBloc>(context).add(StudentListRequested());
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    dropDownRoles = new List();
    dropDownRoles.add("Tous");
    Base.allRoles.forEach((element) {
      dropDownRoles.add(element.toString());
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: CustomTextFormField(
                            "Rechercher...",
                            "Prenom et/ou nom de l'élève",
                            Icons.search,
                            searchController))),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                    padding:
                        EdgeInsets.only(top: 4, bottom: 4, left: 7, right: 5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black38),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButton<String>(
                      underline: Column(),
                      value: selectedRole,
                      onChanged: (String newValue) {
                        setState(() {
                          selectedRole = newValue;
                        });
                      },
                      items: dropDownRoles
                          .map<DropdownMenuItem<String>>((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role,
                              style: TextStyle(
                                  color: role == selectedRole
                                      ? Colors.black
                                      : Colors.black54)),
                        );
                      }).toList(),
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )),
              ])),
      BlocBuilder<StudentsBloc, StudentState>(builder: (context, state) {
        if (state is StudentListInitial) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is StudentListLoadInProgress) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is StudentListLoadSuccess) {
          final students = state.students;

          return Expanded(
              child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (BuildContext context, int index) {
                    filter = searchController.text;
                    StudentModel student = students[index];
                    return (filter == null || filter == "") &&
                            selectedRole == "Tous"
                        ? _studentTile(student, index)
                        : (student.firstname
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()) ||
                                    student.lastname
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()) ||
                                    (student.firstname + " " + student.lastname)
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase())) &&
                                (selectedRole != "Tous" &&
                                        student.roles.contains(Base.allRoles
                                            .firstWhere((element) =>
                                                element.toString() ==
                                                selectedRole)) ||
                                    selectedRole == "Tous")
                            ? _studentTile(student, index)
                            : new Container();
                  }));
        }
        if (state is StudentListLoadFailure) {
          return Text("Aucun " + selectedRole + " pour le moment");
        }
        return Container();
      })
    ]);
  }

  _studentTile(StudentModel student, int index) {
    List<RoleModel> currentRoles = List.from(student.roles);
    Color color = (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9);
    return new Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: color),
        child: ListTile(
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              student.firstname + " " + student.lastname,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              student.mailEsiee.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),
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
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width / 3,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: Base.allRoles.length,
                                itemBuilder: (BuildContext context, int index) {
                                  RoleModel thisRole = Base.allRoles[index];
                                  return SwitchListTile(
                                    title: Text(thisRole.toString()),
                                    value: currentRoles.contains(thisRole),
                                    onChanged: (bool value) {
                                      setState(() {
                                        if (value) {
                                          currentRoles.add(thisRole);
                                        } else {
                                          currentRoles.removeWhere(
                                              (element) => element == thisRole);
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
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          student.roles = List.from(currentRoles);
                          BlocProvider.of<StudentsBloc>(context)
                              .add(StudentToBeSaved(student: student));
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Retour'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          currentRoles = List.from(student.roles);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
        ));
  }
}
