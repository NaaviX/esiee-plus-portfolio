import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/prof_event.dart';
import 'package:bde_esiee_mobile/src/blocs/prof_state.dart';
import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/student_event.dart';
import 'package:bde_esiee_mobile/src/blocs/student_state.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../App.dart';
import 'messenger.dart';
import 'messenger_list.dart';

class MessengerHistory extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MessengerHistoryState();
  }
}

class MessengerHistoryState extends State<MessengerHistory> {
  List<String> groupChatIds = new List();
  List<String> discussions = new List();

  List<StudentModel> allStudents = new List();
  List<ClubModel> allClubs = new List();
  List<ProfModel> allProfs = new List();

  @override
  void initState() {
    BlocProvider.of<StudentsBloc>(context)
        .add(StudentListRequested());
    BlocProvider.of<ProfsBloc>(context)
        .add(ProfsRequested());
    if (Base.allClubs != null && Base.allClubs.length != 0) {
      allClubs.addAll(Base.allClubs);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<StudentsBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentListInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is StudentListLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is StudentListLoadSuccess) {
            final students = state.students;

            allStudents.addAll(students);

            return BlocBuilder<ProfsBloc, ProfState>(
                builder: (context, state) {
                  if (state is ProfsInitial) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is ProfsLoadInProgress) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is ProfsLoadSuccess) {
                    final profs = state.profs;

                    allProfs.addAll(profs);
                    return getConvs();
                  }
                  if (state is ProfsLoadFailure) {
                    return Text(
                      'Something went wrong!',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return Container();
                });
          }
          if (state is StudentListLoadFailure) {
            return Text("Erreur");
          }
          return Container();
        });
  }



  Widget getConvs() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for(var documentRef in snapshot.data.documents) {

              if (documentRef.documentID.contains(user.email) &&
                  !groupChatIds.contains(documentRef.documentID)) {
                groupChatIds.add(documentRef.documentID);
                if (documentRef.documentID.split("::")[0] != user.email) {
                  discussions.add(documentRef.documentID.split("::")[0]);
                } else {
                  discussions.add(documentRef.documentID.split("::")[1]);
                }
              }
            }
          }
          return getList();
        });
  }

  Widget getList() {
    return Scaffold(
      appBar: AppBar(
          title: Text("Discuter avec..."),
          actions: [
            Tooltip(
              message: "ESIEE+ ne peut être tenu pour responssable des propos échanger par message.\n"
                  "En cas de problèmes veuillez en informer immédiatement le BDE.",
              child: Container( child: Icon(Icons.info, size: 25,), margin: EdgeInsets.only(right: 15),),
              showDuration: Duration(seconds: 30),
              waitDuration: Duration(microseconds: 1,),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 50),
            ),
          ]
      ),
      body: discussions.isEmpty
          ? ListTile(

          title: Text("Aucune discussion"))
          : ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemBuilder: (context, index) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection('messages')
                .document(groupChatIds.elementAt(index))
                .collection(groupChatIds.elementAt(index))
                .orderBy('timestamp', descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
              } else {
                var listMessage = snapshot.data.documents;
                int nbMsgNotRead = 0;
                for(var msg in listMessage) {
                  if(msg["hasBeenRead"] == false && msg["from"] != user.email) {
                    nbMsgNotRead++;
                  }
                }
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.person, color: Colors.white,),
                  ),
                  trailing: nbMsgNotRead != 0 ?
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Theme.of(context).accentColor,
                    child: Text(nbMsgNotRead.toString(), style: TextStyle(fontSize: 12, color: Colors.white),),
                  ) : CircleAvatar(radius: 10, backgroundColor: Colors.transparent,),
                  title: Text(discussions.elementAt(index).split("@")[0].replaceAll(".", " ").toUpperCase()),
                  subtitle: lastMessage(nbMsgNotRead, snapshot, index),
                  onTap: () {
                    StudentModel student;
                    ClubModel club;
                    ProfModel prof;
                    try {
                      student = allStudents.firstWhere((element) =>
                      element.mailEsiee == discussions.elementAt(index));
                    } catch (e) {}
                    try {
                      club = allClubs.firstWhere((element) =>
                      element.mail == discussions.elementAt(index));
                    } catch (e) {}
                    try {
                      prof = allProfs.firstWhere((element) =>
                      element.mailEsiee == discussions.elementAt(index));
                    } catch (e) {}
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Messenger(
                          student: student,
                          club: club,
                          prof: prof);
                    }));
                  },
                );
              }
            },
          );
        },
        itemCount: discussions.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MessengerList(profs: allProfs, students: allStudents,);
          }));
        },
        child: const Icon(FontAwesomeIcons.solidCommentDots),
      ),
    );
  }

  lastMessage(int nbMsgNotRead, AsyncSnapshot<dynamic> snapshot, int index) {
    String prenom = discussions.elementAt(index).split("@")[0].split(".")[0];
    String from = snapshot.data.documents[0]["from"] == user.email ? 'vous : ' : '';
    TextStyle style = nbMsgNotRead != 0 ? TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold) : TextStyle();
    String imageFrom = snapshot.data.documents[0]["from"] == user.email ? 'vous avez ' : prenom.substring(0,1).toUpperCase() + prenom.substring(1,prenom.length) + ' vous a ';
    return snapshot.data.documents[0]['type'] == "texte" ?
    Text(from + snapshot.data.documents[0]["content"].toString(), style: style,)
        : Text(imageFrom + 'envoyé une photo', style: style,);
  }


}
