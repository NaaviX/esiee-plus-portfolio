
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClubAddMember extends StatefulWidget {
  final ClubModel thisClub;
  const ClubAddMember(this.thisClub);

  @override
  State<StatefulWidget> createState() {
    return ClubAddMemberState();
  }

}
class ClubAddMemberState extends State<ClubAddMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Gestion des membres"),
    ),
    body: Text("Formulaire d'ajout de membre à un club"));
  }

}