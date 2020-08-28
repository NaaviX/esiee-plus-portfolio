import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
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
  final bloc = ClubsBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchAllClubs();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  final log = Logger('clubList');

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Les clubs"),
        ),
        body: StreamBuilder(
          stream: bloc.allClubs,
          builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
            if (snapshot.hasData) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  Widget buildList(AsyncSnapshot<List<ClubModel>> snapshot) {

    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          if(snapshot.data[index].idClubRef <= 100) {
            return ListTile(
              leading:
              GestureDetector(
                child: Hero(
                  tag: 'logoClub'+snapshot.data[index].idClubRef.toString(),
                  child: CircleAvatar(
                    backgroundColor: Colors.blueGrey.withOpacity(0.2),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data[index].urlPhoto),
                      backgroundColor: Colors.white,
                      radius:19,
                    ),
                  ),
                ),
              ),
              title: Text(snapshot.data[index].name),
              trailing: snapshot.data[index].students.contains(Base.thisUser) ? Icon(Icons.verified_user, color: Colors.green) : Column(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClubInfoPage(club : snapshot.data[index]),),
                );
              },
            );
          }
          else return null;
        });
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }
}