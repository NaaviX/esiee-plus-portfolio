import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_event.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_state.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/FairpayLogCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../App.dart';

class TreasuryManager extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TreasuryManagerState();
  }
}

class TreasuryManagerState extends State<TreasuryManager>{

  List<ClubModel> clubList = List();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FairpayLogsBloc>(context)
        .add(FairpayLogsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestion Trésorerie"),
        ),
        body: BlocBuilder<FairpayLogsBloc, FairpayLogState>(
            builder: (context, state) {
              if (state is FairpayLogsInitial) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is FairpayLogsLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is FairpayLogsLoadSuccess) {
                final fairpayLogs = state.fairpayLogs;

                return Column(
                    children: <Widget>[
                      _topArea(),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child:  _log(fairpayLogs),
                        ),
                      )
                    ]
                );
              }
              if (state is FairpayLogsLoadFailure) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _topArea(),
                      SizedBox(height: 3,),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text("Aucune log pour le moment", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                      )
                    ]
                ) ;
              }
              return Container();
            })
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
                  backgroundColor: Theme.of(context).backgroundColor,
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
    List<ClubModel> clubs = Base.allClubs;
            double total = 0;
    clubs.forEach((club) {
              total += club.solde;
            });
            return Column(
              children: <Widget>[
                Text("$total €",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            );
  }

  Widget _fairpayTotalWithoutBDE(){
    List<ClubModel> clubs = Base.allClubs;
            double total = 0;
    clubs.forEach((club) {
              if( club.idClubRef != 100 )
                total += club.solde;
            });
            return Text("Hors BDE : $total €",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.blue[100])
            );
  }

  _log(List<FairpayLogModel> fairpayLogs) {
    List<FairpayLogModel> ajd = new List<FairpayLogModel>();
    List<FairpayLogModel> sameMonth = new List<FairpayLogModel>();
    List<FairpayLogModel> mandat = new List<FairpayLogModel>();
    List<FairpayLogModel> avantMandat = new List<FairpayLogModel>();

    //mai de l'année dernière
    DateTime mandatPrecedents = DateTime(DateTime.now().year-1, 05);
    //mai de cette année
    DateTime mandatActuel = DateTime(DateTime.now().year, 05);

    DateTime jour = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime mois = DateTime(DateTime.now().year, DateTime.now().month);

    fairpayLogs.forEach((element) {
      DateTime dateLog = element.date;
      DateTime moisLog = DateTime(dateLog.year, dateLog.month);
      DateTime jourLog = DateTime(dateLog.year, dateLog.month, dateLog.day);
      if(jourLog == jour) ajd.add(element);
      else if(moisLog == mois) sameMonth.add(element);
      else if(DateTime.now().month < 05) {
        if(moisLog.isAfter(mandatPrecedents)) mandat.add(element);
        else avantMandat.add(element);
      }
      else if(DateTime.now().month >= 05)
      {
        if(moisLog.isAfter(mandatActuel)) mandat.add(element);
        else avantMandat.add(element);
      }
      else avantMandat.add(element);
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
              sameMonth.isNotEmpty ? Text("Plus tôt ce mois-ci", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),) : Container(),
              sameMonth.isNotEmpty ? getTextWidgets(sameMonth) : Container(),
              sameMonth.isNotEmpty ? SizedBox(height: 20,) : Container(),
              mandat.isNotEmpty ?  Text("Plus tôt dans le mandat", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),) : Container(),
              mandat.isNotEmpty ? getTextWidgets(mandat) : Container(),
              mandat.isNotEmpty ? SizedBox(height: 20,) : Container(),
              avantMandat.isNotEmpty ?  Text("Pendant les mandats précédents", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),) : Container(),
              avantMandat.isNotEmpty ? getTextWidgets(avantMandat) : Container(),
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
      color: MyTheme.ColorTheme(context, colorLight: MyTheme.LightBackground, colorDark: MyTheme.PrimaryColorLight.withOpacity(0.4)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(children: list),
    );
  }
}