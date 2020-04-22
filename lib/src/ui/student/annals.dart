import 'package:flutter/material.dart';

class AnnalsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnnalsListState();
  }
}

class AnnalsListState extends State<AnnalsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Annals"),
        ),
        body:Text("TO DO"));
  }
}