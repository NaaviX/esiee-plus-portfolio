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

  Widget buildList(AsyncSnapshot<List<ClubModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            /*leading: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data[index].urlPhoto),
            ),*/
            title: Text(snapshot.data[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Fairpay2(snapshot.data[index])),
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

class Fairpay2 extends StatefulWidget {

  final ClubModel thisClub;
  const Fairpay2(this.thisClub);

  @override
  State<StatefulWidget> createState() {
    return FairpayState2();
  }
}

class FairpayState2 extends State<Fairpay2>{
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

  final log = Logger('Fairpay Club');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fairpay"),
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
                padding: EdgeInsets.all(20.0),
                child: Text("${widget.thisClub.solde.toString()}  €",
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