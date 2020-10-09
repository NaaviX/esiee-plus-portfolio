import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../../App.dart';
import '../../blocs/clubs_bloc.dart';

class ClubList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClubListState();
  }
}

class ClubListState extends State<ClubList> {

  final log = Logger('clubList');

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Les clubs"),
        ),
        body: buildList(Base.allClubs)

        );
  }

  Widget buildList(List<ClubModel> clubs) {
    clubs.removeWhere((element) => element.idClubRef > 100);
    return ListView.builder(
        itemCount: clubs.length,
        itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading:
              GestureDetector(
                child: Hero(
                  tag: 'logoClub'+clubs[index].idClubRef.toString(),
                  child: CircleAvatar(
                    backgroundColor: Colors.blueGrey.withOpacity(0.2),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(clubs[index].urlPhoto),
                      backgroundColor: Colors.white,
                      radius:19,
                    ),
                  ),
                ),
              ),
              title: Text(clubs[index].name),
              trailing: clubs[index].students.contains(Base.thisUser) ? Icon(Icons.verified_user, color: Colors.green) : Column(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClubInfoPage(club : clubs[index]),),
                );
              },
            );
        });
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }
}