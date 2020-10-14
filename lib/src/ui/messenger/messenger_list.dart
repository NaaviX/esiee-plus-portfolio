import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/KeeAlivePage.dart';
import 'package:flutter/material.dart';

import '../../App.dart';
import 'messenger.dart';

class MessengerList extends StatefulWidget {
  final List<ProfModel> profs;
  final List<StudentModel> students;

  MessengerList({Key key, @required this.profs, @required this.students})
      : assert(profs != null && students != null),
        super(key: key);

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

      links.add(KeepAlivePage(
          child: MessengerStudentList(students: widget.students)));
      links.add(KeepAlivePage(child: MessengerClubList()));
    } else if (Base.thisClub != null) {
      tabs.add(Tab(
        icon: Icon(Icons.person),
        text: "Etudiants",
      ));
      tabs.add(Tab(icon: Icon(Icons.school), text: "Professeurs"));

      links.add(KeepAlivePage(
          child: MessengerStudentList(students: widget.students)));
      links.add(KeepAlivePage(child: MessengerProfList(profs: widget.profs)));
    } else {
      tabs.add(Tab(icon: Icon(Icons.people), text: "Clubs"));
      tabs.add(Tab(icon: Icon(Icons.school), text: "Professeurs"));

      links.add(KeepAlivePage(child: MessengerClubList()));
      links.add(KeepAlivePage(child: MessengerProfList(profs: widget.profs)));
    }
    super.initState();
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
            )));
  }
}

class MessengerClubList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessengerClubListState();
  }
}

class MessengerClubListState extends State<MessengerClubList> {
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
}

class MessengerStudentList extends StatefulWidget {
  final List<StudentModel> students;

  MessengerStudentList({Key key, @required this.students})
      : assert(students != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MessengerStudentListState();
  }
}

class MessengerStudentListState extends State<MessengerStudentList> {
  final searchController = TextEditingController();

  String filter = "";

  List<String> history = new List();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.students != null && widget.students.length != 0) {
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
                ])),
        Expanded(
            child: ListView.builder(
                itemCount: widget.students.length,
                itemBuilder: (BuildContext context, int index) {
                  filter = searchController.text;
                  StudentModel student = widget.students[index];
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
}

class MessengerProfList extends StatefulWidget {
  final List<ProfModel> profs;

  MessengerProfList({Key key, @required this.profs})
      : assert(profs != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MessengerProfListState();
  }
}

class MessengerProfListState extends State<MessengerProfList> {
  final searchController = TextEditingController();

  String filter = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profs != null && widget.profs.length != 0) {
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
                              "Prenom et/ou nom du professeur",
                              Icons.search,
                              searchController))),
                ])),
        Expanded(
            child: ListView.builder(
                itemCount: widget.profs.length,
                itemBuilder: (BuildContext context, int index) {
                  filter = searchController.text;
                  ProfModel prof = widget.profs[index];
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
}
