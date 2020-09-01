import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';

import '../../App.dart';
import 'messenger.dart';

class MessengerList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessengerListState();
  }
}

class MessengerListState extends State<MessengerList> {
  List<Tab> tabs = [];
  List<Widget> links = [];

  @override
  void initState() {
    if (Base.thisProf != null) {
      tabs.add(Tab(
        icon: Icon(Icons.person),
        text: "Etudiants",
      ));
      tabs.add(Tab(icon: Icon(Icons.people), text: "Clubs"));

      links.add(MessengerStudentList());
      links.add(MessengerClubList());
    } else if(Base.thisClub != null) {
      tabs.add(Tab(
        icon: Icon(Icons.person),
        text: "Etudiants",
      ));
      tabs.add(Tab(icon: Icon(Icons.school), text: "Professeurs"));

      links.add(MessengerStudentList());
      links.add(MessengerProfList());
    } else {
      tabs.add(Tab(icon: Icon(Icons.people), text: "Clubs"));
      tabs.add(Tab(icon: Icon(Icons.school), text: "Professeurs"));

      links.add(MessengerClubList());
      links.add(MessengerProfList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: tabs,
              ),
              title: Text("Discuter avec..."),
            ),
            body: TabBarView(
              children: links,
            )
        )
    );
  }
}

class MessengerClubList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessengerClubListState();
  }
}

class MessengerClubListState extends State<MessengerClubList>
    with AutomaticKeepAliveClientMixin {
  ClubsBloc clubsBloc = ClubsBloc();

  @override
  void initState() {
    clubsBloc.fetchAllClubs();
    super.initState();
  }

  @override
  void dispose() {
    clubsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: clubsBloc.allClubs,
        builder: (context, AsyncSnapshot<List<ClubModel>> clubSnapshot) {
          if (clubSnapshot.hasData) {
            return ListView.builder(
                itemCount: clubSnapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ClubModel club = clubSnapshot.data[index];
                  return _clubTile(club);
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  ListTile _clubTile(ClubModel club) {
    return new ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(club.urlPhoto),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      title: Text(club.name),
      subtitle: Text(
        club.mail,
      ),
      onTap: () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return Messenger(club: club);
        }));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MessengerStudentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessengerStudentListState();
  }
}

class MessengerStudentListState extends State<MessengerStudentList>
    with AutomaticKeepAliveClientMixin {
  StudentsBloc studentsBloc = StudentsBloc();

  final searchController = TextEditingController();

  String filter = "";

  List<String> history = new List();

  @override
  void initState() {
    super.initState();
    studentsBloc.fetchAllStudents();

//        .snapshots().forEach((element) {print(element.documentID);});
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: studentsBloc.allStudents,
        builder: (context, AsyncSnapshot<List<StudentModel>> studentSnapshot) {
          if (studentSnapshot.hasData) {
            return Column(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                      ])),
              Expanded(
                  child: ListView.builder(
                      itemCount: studentSnapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        filter = searchController.text;
                        StudentModel student = studentSnapshot.data[index];
                        return (filter == null || filter == "")
                            ? _studentTile(student, index)
                            : (student.firstname
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()) ||
                                    student.lastname
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()) ||
                                    (student.firstname + " " + student.lastname)
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()))
                                ? _studentTile(student, index)
                                : new Container();
                      }))
            ]);
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  _studentTile(StudentModel student, int index) {
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
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return Messenger(student: student);
            }));
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class MessengerProfList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessengerProfListState();
  }
}

class MessengerProfListState extends State<MessengerProfList>
    with AutomaticKeepAliveClientMixin {
  ProfsBloc profsBloc = ProfsBloc();

  final searchController = TextEditingController();

  String filter = "";

  @override
  void initState() {
    super.initState();
    profsBloc.fetchAllProfs();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    profsBloc.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: profsBloc.allProfs,
        builder: (context, AsyncSnapshot<List<ProfModel>> profSnapshot) {
          if (profSnapshot.hasData) {
            return Column(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                            child: Container(
                                margin: EdgeInsets.all(10),
                                child: CustomTextFormField(
                                    "Rechercher...",
                                    "Prenom et/ou nom du professeur",
                                    Icons.search,
                                    searchController))),
                      ])),
              Expanded(
                  child: ListView.builder(
                      itemCount: profSnapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        filter = searchController.text;
                        ProfModel prof = profSnapshot.data[index];
                        return (filter == null || filter == "")
                            ? _profTile(prof, index)
                            : (prof.firstname
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()) ||
                                    prof.lastname
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()) ||
                                    (prof.firstname + " " + prof.lastname)
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()))
                                ? _profTile(prof, index)
                                : new Container();
                      }))
            ]);
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  _profTile(ProfModel prof, int index) {
    Color color = (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9);
    return new Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: color),
        child: ListTile(
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              prof.firstname + " " + prof.lastname,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              prof.mailEsiee.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),
          onTap: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return Messenger(prof: prof);
            }));
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
