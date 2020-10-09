import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../App.dart';

class FairpayLogCard extends StatefulWidget {

  @required final BuildContext context;
  @required final FairpayLogModel log;

  FairpayLogCard(this.log, this.context);

  @override
  State<StatefulWidget> createState() {
    return FairpayLogCardState();
  }
}

class FairpayLogCardState extends State<FairpayLogCard> {

  @override
  Widget build(BuildContext context) {
    final FairpayLogModel log = widget.log;
    return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    //direction: Axis.horizontal,
                    //alignment: WrapAlignment.start,
                    children: <Widget>[
                      clubLogo(Base.allClubs.firstWhere((element) => element.idClubRef == widget.log.idClubRef)),
                      SizedBox(width: 15,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 235,
                            child: AutoSizeText(log.description, style: TextStyle(color: Colors.black87, fontSize: 20), maxLines: 3,),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 235,
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Text(formatDate(log.date) + ' · ', style: TextStyle(color: Colors.black54, fontSize: 12, fontStyle: FontStyle.italic)),
                                SizedBox(height: 2,),
                                Text(nameToInitial(log.userName), style: TextStyle(color: Colors.black54, fontSize: 12, fontStyle: FontStyle.italic),),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 5,),
                      Container(
                          alignment: Alignment.centerRight,
                          width: 95,
                          child: AutoSizeText(log.amount.toString() + ' €', style: TextStyle(color: colorStyle(widget.log.type), fontSize: 20, fontWeight: FontWeight.bold,), maxLines: 1,)
                      )
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1,),
              ]
          );
  }

  nameToInitial(String name){
    return name == "unknown" ? "" : "${name.split(" ")[0][0]}. ${name.split(" ")[1]}";
  }

  clubLogo(ClubModel club) {
    NetworkImage backgroundImage;
    club!=null ? backgroundImage = NetworkImage(club.urlPhoto) : backgroundImage = null;
    return Container(
      child: CircleAvatar(
        backgroundImage: backgroundImage,
        radius: 17,
      ),
    );
  }

  String formatDate(DateTime date)
  {
    return DateFormat.yMd('fr_FR').format(date);
  }

  MaterialColor colorStyle(String type) {
    switch (type) {
      case "Depot":
        return Colors.green;
      case "Retrait":
        return Colors.red;
      case "Subvention":
        return Colors.orange;
    }
    return Colors.grey;
  }
}