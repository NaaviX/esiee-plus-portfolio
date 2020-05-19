import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/FairpayLogCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TreasuryManager extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TreasuryManagerState();
  }
}

class TreasuryManagerState extends State<TreasuryManager>{
  final clubsBloc = ClubsBloc();
  final Logbloc = FairpayLogBloc();

  List<ClubModel> clubList = List();

  @override
  void initState() {
    super.initState();
    clubsBloc.fetchAllClubs();
    Logbloc.fetchAllLogs();
  }

  @override
  void dispose() {
    clubsBloc.dispose();
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
                    _topArea(),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child:  _log(snapshot),
                      ),
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

  _topArea() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _fairpayTotal(),
                    SizedBox(height: 5,),
                    _fairpayTotalWithoutBDE(),
                  ]
              ),
              Container(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Icon(Icons.account_balance, size: 40, color: Theme.of(context).primaryColor,),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fairpayTotal(){
    return StreamBuilder(
        stream: clubsBloc.allClubs,
        builder: (context, AsyncSnapshot<List<ClubModel>> clubList) {
          if(clubList.hasData) {
            double total = 0;
            clubList.data.forEach((club) {
              total += club.solde;
            });
            return Column(
              children: <Widget>[
                Text("${total} €",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            );
          }
          return Text("Loading...",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
              )
          );
        }
    );
  }

  Widget _fairpayTotalWithoutBDE(){
    return StreamBuilder(
        stream: clubsBloc.allClubs,
        builder: (context, AsyncSnapshot<List<ClubModel>> clubList) {
          if(clubList.hasData) {
            double total = 0;
            clubList.data.forEach((club) {
              if( club.idClubRef != 100 )
                total += club.solde;
            });
            return Text("Hors BDE : ${total} €",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.blue[100])
            );
          }
          return Text("Hors BDE : loading...",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.blue[100])
          );
        }
    );
  }

  _log(AsyncSnapshot<List<FairpayLogModel>> snapshot) {
    List<FairpayLogModel> ajd = new List<FairpayLogModel>();
    List<FairpayLogModel> same_month = new List<FairpayLogModel>();
    List<FairpayLogModel> mandat = new List<FairpayLogModel>();
    List<FairpayLogModel> avant_mandat = new List<FairpayLogModel>();

    //mai de l'année dernière
    DateTime mandat_pressedants = DateTime(DateTime.now().year-1, 05);
    //mai de cette année
    DateTime mandat_actuel = DateTime(DateTime.now().year, 05);

    DateTime jour = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime mois = DateTime(DateTime.now().year, DateTime.now().month);

    snapshot.data.forEach((element) {
      DateTime date_log = element.date;
      DateTime mois_log = DateTime(date_log.year, date_log.month);
      DateTime jour_log = DateTime(date_log.year, date_log.month, date_log.day);
      if(jour_log == jour) ajd.add(element);
      else if(mois_log == mois) same_month.add(element);
      else if(DateTime.now().month < 05) {
        if(mois_log.isAfter(mandat_pressedants)) mandat.add(element);
        else avant_mandat.add(element);
      }
      else if(DateTime.now().month >= 05)
      {
        if(mois_log.isAfter(mandat_actuel)) mandat.add(element);
        else avant_mandat.add(element);
      }
      else avant_mandat.add(element);
    });

    return ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ajd.isNotEmpty ? Text("Aujourd'hui", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),) : Container(),
              ajd.isNotEmpty ? getTextWidgets(ajd) : Container(),
              ajd.isNotEmpty ? SizedBox(height: 20,) : Container(),
              same_month.isNotEmpty ? Text("Plus tôt ce mois-ci", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),) : Container(),
              same_month.isNotEmpty ? getTextWidgets(same_month) : Container(),
              same_month.isNotEmpty ? SizedBox(height: 20,) : Container(),
              mandat.isNotEmpty ?  Text("Plus tôt dans le mandat", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),) : Container(),
              mandat.isNotEmpty ? getTextWidgets(mandat) : Container(),
              mandat.isNotEmpty ? SizedBox(height: 20,) : Container(),
              avant_mandat.isNotEmpty ?  Text("Pendant les mandats précédents", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),) : Container(),
              avant_mandat.isNotEmpty ? getTextWidgets(avant_mandat) : Container(),
            ],
          )
        ]
    );
  }

  Widget getTextWidgets(List<FairpayLogModel> log)
  {
    List<Widget> list = new List<Widget>();
    log.forEach((element) => list.add(new FairpayLogCard(element, context)));
    return new Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(children: list),
    );
  }
}