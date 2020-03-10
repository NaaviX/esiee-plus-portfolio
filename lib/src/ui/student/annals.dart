import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Annals extends StatefulWidget {
  final databaseReference = Firestore.instance;

  @override
  State<StatefulWidget> createState() {
    RaisedButton(
      child: Text('Create Record'),
      onPressed: () {
        createRecord();
      },
    );
    return null;
  }

  void createRecord() async {
    await databaseReference.collection("cours")
        .document("1")
        .setData({
      'unité': 'Mastering Flutter',
      'description': 'Programming Guide for Dart'
    });

    DocumentReference ref = await databaseReference.collection("books")
        .add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    print(ref.documentID);
  }


}