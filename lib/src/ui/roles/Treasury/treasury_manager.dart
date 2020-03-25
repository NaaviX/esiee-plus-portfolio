import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './indicator.dart';

class TreasuryManager extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TreasuryManagerState();
  }
}

class TreasuryManagerState extends State<TreasuryManager>{
  final Logbloc = FairpayLogBloc();

  @override
  void initState() {
    super.initState();
    Logbloc.fetchAllLogs();
  }

  @override
  void dispose() {
    Logbloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Gestion Trésorerie"),
    ),
        body: StreamBuilder(
          stream: Logbloc.allFairpayLog,
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
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Total Fairpay : ? €",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0, fontWeight: FontWeight.bold)),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Total hors BDE : ? €",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15.0, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )),
  );

  Widget buildList(AsyncSnapshot<List<FairpayLogModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return transactionRow(snapshot.data[index], oddColour: (index % 2 == 0) ? Color(0xFFF7F7F9) : Colors.white);
        }
    );
  }

  Container transactionRow( FairpayLogModel log, {Color oddColour = Colors.white} ) => Container(
    decoration: BoxDecoration(color: oddColour),
    padding: EdgeInsets.only(top: 15.0, bottom: 10.0, left: 5.0, right: 5.0),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(DateFormat('d MMM').format(log.date), style: TextStyle(color: Colors.grey, fontSize: 14.0))
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 15.0),
            transIcon(log.amount),
            transText(log.amount),
            SizedBox(width: 25.0),
            Text("${log.idClubRef} : ${log.description}", style: TextStyle(fontSize: 16.0)),
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