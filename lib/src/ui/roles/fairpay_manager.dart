import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/ui/club/fairpay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';


class FairPayManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FairPayManagerState();
  }
}

class FairPayManagerState extends State<FairPayManager> {
  final clubsBloc = ClubsBloc();
  final fairPayBloc = FairpayLogBloc();

  @override
  void initState() {
    super.initState();
    clubsBloc.fetchAllClubs();
  }

  @override
  void dispose() {
    clubsBloc.dispose();
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
          stream: clubsBloc.allClubs,
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
                MaterialPageRoute(builder: (context) => Fairpay(snapshot.data[index])),
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
class ClubFairPayPage extends StatelessWidget{

  final ClubModel club;
  ClubFairPayPage({this.club});

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