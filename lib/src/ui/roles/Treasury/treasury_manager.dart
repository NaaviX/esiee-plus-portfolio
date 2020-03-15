import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:flutter/material.dart';
import './indicator.dart';

class TreasuryManager extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TreasuryManagerState();
  }
}

class TreasuryManagerState extends State<TreasuryManager>{
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Dashboard Trésorerie"),
    ),
    body: topArea()
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
                child: Text("1000",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 30.0, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )),
  );

}