import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  StudentsBloc studentsBloc = StudentsBloc();
  ClubsBloc clubsBloc = ClubsBloc();
  ProfsBloc profsBloc = ProfsBloc();

  List<StudentModel> allStudents = new List();
  List<ClubModel> allClubs = new List();
  List<ProfModel> allProfs = new List();

  @override
  void dispose() {
    super.dispose();
    studentsBloc.dispose();
    clubsBloc.dispose();
    profsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: studentsBloc.allStudents,
      builder: (context, AsyncSnapshot<List<StudentModel>> snapshot) {
        if (snapshot.hasData) {
          allStudents.addAll(snapshot.data);
        }
        return StreamBuilder(
            stream: clubsBloc.allClubs,
            builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
              if (snapshot.hasData) {
                allClubs.addAll(snapshot.data);
              }
              return StreamBuilder(
                stream: profsBloc.allProfs,
                builder: (context, AsyncSnapshot<List<ProfModel>> snapshot) {
                  if (snapshot.hasData) {
                    allProfs.addAll(snapshot.data);
                  }
                  return getConvs();
                },
              );
            });
      },
    );
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

//
  }

  Widget getList() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discuter avec..."),
      ),
      body: discussions.isEmpty
          ? ListTile(

        title: Text("Aucune discussion"))
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.all(10.0),
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
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(PrimaryColor)));
                    } else {
                      var listMessage = snapshot.data.documents;
                      int nbMsgNotRead = 0;
                      for(var msg in listMessage) {
                        if(msg["hasBeenRead"] == false && msg["from"] != user.email) {
                          nbMsgNotRead++;
                        }
                      }
                      return ListTile(
                        trailing: Chip(
                          avatar: CircleAvatar(
                            radius: 8,
                            backgroundColor: nbMsgNotRead>0 ? SecondaryColor : Colors.transparent,
                            child: Text(''),
                          ),
                          label: Text(""),
                          //label: nbMsgNotRead>0 ? Text(nbMsgNotRead.toString()) : Text(""),
                          //backgroundColor: nbMsgNotRead>0 ? SecondaryColor : Colors.transparent,
                        ),
                        title: Text(discussions.elementAt(index).split("@")[0].replaceAll(".", " ").toUpperCase()),
                        subtitle: nbMsgNotRead>0 ?
                          Text(nbMsgNotRead.toString() + " nouveaux messages"/*discussions.elementAt(index),*/)
                        : Text("T'es con"/*discussions.elementAt(index),*/),
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
            return MessengerList();
          }));
        },
        child: const Icon(FontAwesomeIcons.solidCommentDots),
      ),
    );
  }

  @override
  void initState() {
    studentsBloc.fetchAllStudents();
    clubsBloc.fetchAllClubs();
    profsBloc.fetchAllProfs();
  }
}
