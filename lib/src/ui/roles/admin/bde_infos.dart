import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BdeInfos extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String quoteSIRET = "362 521 879 00034";
    String quoteSIREN = "519 464 267";
    String quoteIBAN = "FR7630001007941234567890185";
    String quoteBIC = "CCBPFRPPVER";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Informations BDE"),
      ),

      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[
              Image(image: AssetImage('assets/info.png'), height: MediaQuery.of(context).size.height/6,),
              Expanded(
                  child: ListView (
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: <Widget>[
                      Text("Administatif", style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      info(
                        context,
                        FontAwesomeIcons.university,
                        "SIRET",
                        quoteSIRET,
                      ),
                      info(
                        context,
                        FontAwesomeIcons.university,
                        "SIREN",
                        quoteSIREN,
                      ),
                      SizedBox(height: 10,),
                      Text("Banque", style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      info(
                        context,
                        FontAwesomeIcons.moneyCheckAlt,
                        "IBAN",
                        quoteIBAN,
                      ),
                      info(
                        context,
                        FontAwesomeIcons.moneyCheckAlt,
                        "BIC",
                        quoteBIC,
                      ),
                    ],
                  )
              ),
            ],
          )
      ),
    );
  }

  info(context, IconData icon, String titre, String text) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 30.0),
        title: Text(titre, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
        subtitle: AutoSizeText(text, style: TextStyle(fontSize: 20), maxLines: 1,),
        trailing: IconButton(
          icon: Icon(Icons.content_copy),
          color: Colors.cyan,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text(titre + " copié dans le presse-papier !"),
                  backgroundColor: Theme.of(context).primaryColor,
                )
            );//toast(titre);
          },
        ),
      ),
    );
  }
}