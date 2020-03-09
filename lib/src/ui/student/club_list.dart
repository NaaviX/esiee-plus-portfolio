import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../../blocs/clubs_bloc.dart';
import 'package:intl/intl.dart';

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
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data[index].urlPhoto),
            ),
            title: Text(snapshot.data[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClubInfoPage(club : snapshot.data[index])),
              );
            },
          );
        });
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }



}

//When user click on a club
class ClubInfoPage extends StatelessWidget{

  final ClubModel club;
  ClubInfoPage({this.club});

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(club.name),
      ),
      body: Center(
        child: Image.network(
        club.urlPhoto,
        )
      ),
    );
  }
}

