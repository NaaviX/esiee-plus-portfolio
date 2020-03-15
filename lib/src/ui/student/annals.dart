import 'package:cloud_firestore/cloud_firestore.dart';
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
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200.0)),
      elevation: 2.0,
      onPressed: add,
      child: Text("start"),
      color: Colors.white,
    );
  }

  add() {
    Firestore.instance.collection('Message')
        .document('message'+DateTime.now().microsecondsSinceEpoch.toString())
        .setData(
        { 'type':'msg',
          'subject':'sub',
          'description':'description',
          'to':'user1',
          'from':'uid',
        });
  }
}