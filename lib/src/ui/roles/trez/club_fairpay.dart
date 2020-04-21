import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import 'fairpay_form.dart';


class Fairpay extends StatefulWidget {

  ClubModel club;
  bool isTrez;

  Fairpay({this.club, this.isTrez}) {
    this.club != null ? this.club = this.club : this.club = Base.thisClub;
    this.isTrez != null ? this.isTrez = this.isTrez : this.isTrez = false;
  }

  @override
  State<StatefulWidget> createState() {
    return FairpayState();
  }
}

class FairpayState extends State<Fairpay>{
  final Logbloc = FairpayLogBloc();

  @override
  void initState() {
    super.initState();
    Logbloc.fetchClubLogs(widget.club.idClubRef.toString());
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
        title: widget.isTrez ? Text(widget.club.name) : Text("Fairpay"),
      ),
      body: StreamBuilder(
          stream: Logbloc.ClubFairpayLog,
          builder: (context, AsyncSnapshot<List<FairpayLogModel>> snapshot) {
            if (snapshot.hasData){
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Stack(
                  children: <Widget>[
                    _header(),
                    _log(snapshot),
                  ],
                ),
              );
            }
            else if (snapshot.hasError) {
              return
                Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }
      ),
    );
  }

  _header() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.club.solde.toString()}  €", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700),),
                    Text("Solde Actuel", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.blue[100]),),
                  ]
              ),
              Container(
                  child: Hero(
                    tag: "fairpay"+widget.club.idClubRef.toString(),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(widget.club.urlPhoto, fit: BoxFit.contain,),
                      ),
                    ),
                  )
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child :_buttonsHeader(),
          ),
        ],
      ),
    );
  }

  _buttonsHeader() {
    if(widget.isTrez)
      return  ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _button(Colors.green, Icons.file_download, 'Dépot'),
          _button(Colors.red, Icons.file_upload, 'Retrait'),
          _button(Colors.orange, Icons.verified_user, 'Subvention'),
        ],
      );
    else return Container();
  }

  _button(Color color, IconData icon, String text) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      color: color,
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 20,),
          Container(width: 4,),
          Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.white)
          ),
        ],
      ),
      onPressed: () => showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return FairpayForm(text, widget.club);
          }
      )
    );
  }

  _log(AsyncSnapshot<List<FairpayLogModel>> snapshot,) {
    return DraggableScrollableSheet(
      builder: (context, scrollController){
        return Container(
          decoration: BoxDecoration(
              color: Colors.white10.withOpacity(1),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20,),

                  //Container for buttons
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text("Toutes", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [BoxShadow(color: Colors.grey[200], blurRadius: 10.0, spreadRadius: 4.5)]
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        SizedBox(width: 16,),
                        Container(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.green,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Dépot", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [BoxShadow(color: Colors.grey[200], blurRadius: 10.0, spreadRadius: 4.5)]
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        SizedBox(width: 16,),
                        Container(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.red,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Retrait", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [BoxShadow(color: Colors.grey[200], blurRadius: 10.0, spreadRadius: 4.5)]
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ],
                    ),
                  ),

                  Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: buildList(snapshot,)
                  ),
                ],
              ),
              controller: scrollController,
            ),
          ),
        );
      },
      initialChildSize: widget.isTrez ? 0.77 : 0.85,
      minChildSize: widget.isTrez ? 0.77 : 0.85,
      maxChildSize: 0.85,
    );
  }

  Widget buildList(AsyncSnapshot<List<FairpayLogModel>> snapshot,) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        controller: ScrollController(keepScrollOffset: false),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return transactionRow(snapshot.data[index], oddColour: (index % 2 == 0) ? Color(0xFFF7F7F9) : Colors.white);
        }
    );
  }

  Container transactionRow(FairpayLogModel log, {Color oddColour = Colors.white} ) => Container(
    decoration: BoxDecoration(color: oddColour),
    padding: EdgeInsets.only(top: 15.0, bottom: 10.0, left: 5.0, right: 5.0),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(DateFormat('d MMM').format(log.date), style: TextStyle(color: Colors.grey, fontSize: 14.0)),
            Text(nameToInitial(log.userName), style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 12.0))
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
            Text(log.description, style: TextStyle(fontSize: 16.0))
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );

  String nameToInitial(String name){
    return name == "unknown" ? "" : "${name.split(" ")[0][0]}. ${name.split(" ")[1]}";
  }

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
