import 'package:flutter/material.dart';

class TreasuryDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard Trésorerie"),
        ),
        body:ListView(
            children: <Widget>[
              ListTile(title: Text("545 Cotisants / 2000 élèves")),
              ListTile(title: Text("Subvention CCI")),
              ListTile(title: Text("1 millions € dépensés     3,45 € restants")),
            ]
        )
    );
  }


}