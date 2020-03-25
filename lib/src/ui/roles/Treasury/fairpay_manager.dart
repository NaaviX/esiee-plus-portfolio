import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
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
          title: Text("Gestion Fairpay"),
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

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }

  GridView buildList( AsyncSnapshot<List<ClubModel>> snapshot ){
    return new GridView.count(
      crossAxisCount: 3,
      children: new List<Widget>.generate(snapshot.data.length, (index) {
        return _clubTile(snapshot.data[index]);
      }),
    );
  }

  Widget _clubTile(ClubModel club) => GestureDetector(
      child: Padding(
          padding: EdgeInsets.only(top: 4.0, bottom: 12.0),
      child: GridTile(
        child: Column(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(club.urlPhoto), radius: 50, backgroundColor: Colors.grey.withOpacity(0.1)),
              Padding(padding: EdgeInsets.all(1.0)),
              Text( " ${club.solde.toString()} €", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey))
            ]
        ),
      )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FairpayManager(club)),
        );
      }
  );

  /*Column _clubTile(ClubModel club) {
    return new Column(
      children: [
      CircleAvatar(backgroundImage: NetworkImage(club.urlPhoto), backgroundColor: Colors.grey.withOpacity(0.1)),
      Text(formatClubName(club.name)),
      Text("${club.solde} €")
      ]
    );
    /*onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FairpayManager(club)),
      )
    }
    );*/
  }*/

  String formatClubName(String clubName){
    switch (clubName) {
      case "Club esiee sans frontières":
        return "ESF";
      case "Bureau des Sports":
        return "BDS";
      case "Bureau des étudiants":
        return "BDE";
      case "Club dj":
        return "DJ";
      default:
        return clubName.replaceAll("Club ","").toUpperCase();
    }
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

class FairpayManager extends StatefulWidget {

  final ClubModel thisClub;
  const FairpayManager(this.thisClub);

  @override
  State<StatefulWidget> createState() {
    return FairpayManagerState();
  }
}

class FairpayManagerState extends State<FairpayManager>{
  final Logbloc = FairpayLogBloc();

  @override
  void initState() {
    super.initState();
    Logbloc.fetchClubLogs(widget.thisClub.idClubRef.toString());
  }

  @override
  void dispose() {
    Logbloc.dispose();
    super.dispose();
  }

  final log = Logger('Fairpay Club');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.thisClub.name.toString()),
        ),
        body: StreamBuilder(
          stream: Logbloc.ClubFairpayLog,
          builder: (context, AsyncSnapshot<List<FairpayLogModel>> snapshot) {
            if (snapshot.hasData){
              return Column(
                  children: <Widget>[
                    topArea(),
                    Expanded(
                        child: buildList(snapshot)
                    )
                  ]
              );
            }
            else if (snapshot.hasError) {
              return
                Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  Card topArea() => Card(
    margin: EdgeInsets.all(10.0),
    elevation: 1.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
    child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5.0)),
            CircleAvatar(backgroundImage: NetworkImage(widget.thisClub.urlPhoto), radius: 50, backgroundColor: Colors.grey.withOpacity(0.1)),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(" ${widget.thisClub.solde.toString()} €",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 30.0, fontWeight: FontWeight.bold)),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text('Dépot'),
                  color: Colors.blue,
                  onPressed: () {/** */},
                ),
                FlatButton(
                  child: Text('Retrait'),
                  color: Colors.red,
                  onPressed: () {/** */},
                ),
              ],
            )
          ],
        )),
  );

  Widget buildList(AsyncSnapshot<List<FairpayLogModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return transactionRow(snapshot.data[index].amount, snapshot.data[index].date, snapshot.data[index].description, oddColour: (index % 2 == 0) ? Color(0xFFF7F7F9) : Colors.white);
        }
    );
  }

  Container transactionRow( double amount, DateTime date, String description, {Color oddColour = Colors.white} ) => Container(
    decoration: BoxDecoration(color: oddColour),
    padding: EdgeInsets.only(top: 15.0, bottom: 10.0, left: 5.0, right: 5.0),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(DateFormat('d MMM').format(date), style: TextStyle(color: Colors.grey, fontSize: 14.0))
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 15.0),
            transIcon(amount),
            transText(amount),
            SizedBox(width: 25.0),
            Text(description, style: TextStyle(fontSize: 16.0))
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );

  Widget transIcon(double amount){
    int quarter = amount < 0 ? 1 : 0;
    Color color = amount < 0 ? Colors.red : Colors.green;
    return RotatedBox(
        quarterTurns: quarter,
        child: Icon(Icons.call_made, color: color));
  }

  Widget transText(double amount){
    Color color = amount < 0 ? Colors.red : Colors.green;
    String text = amount < 0 ? amount.toStringAsFixed(2) : '+'+amount.toStringAsFixed(2);
    return Text(text.padRight(8,'  '), style: TextStyle(fontSize: 16.0, color: color, fontWeight: FontWeight.bold ));
  }


}