import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BdeInfos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String quoteSIRET = "362 521 879 00034";
    String quoteSIREN = "519 464 267";
    String quoteIBAN = "FR7630001007941234567890185";
    String quoteBIC = "CCBPFRPPVER";

    return Scaffold(
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
                        FontAwesomeIcons.university,
                        "SIRET",
                        quoteSIRET,
                      ),
                      info(
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
                        FontAwesomeIcons.moneyCheckAlt,
                        "IBAN",
                        quoteIBAN,
                      ),
                      info(
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

  info(IconData icon, String titre, String text) {
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
            toast(titre);
          },
        ),
      ),
    );
  }

  toast(String titre) {
    return Fluttertoast.showToast(
      msg: titre + " copié dans le presse-papier !",
      timeInSecForIos: 2,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
/*Card(
          child:
              Column(
                mainAxisSize:MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading:Icon(Icons.perm_identity),
                    title: Text("SIRET"),
                    subtitle: Text(quoteSIRET),
                  ),
                  //Spacer(),
                  ButtonBar(
                    children: <Widget>[

                      ),
                    ],
                  ),

                  ListTile(
                    leading:Icon(Icons.assignment_ind),
                    title: Text("SIREN"),
                    subtitle: Text(quoteSIREN),
                  ),
                  //Spacer(),
                  ButtonBar(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.content_copy),
                        color: Colors.cyan,
                        onPressed: (){
                          Clipboard.setData(ClipboardData(text: quoteSIREN));
                          Fluttertoast.showToast(
                            msg: "SIREN Copié dans le presse-papier !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      ),
                    ],
                  ),

                  ListTile(
                    leading:Icon(Icons.credit_card),
                    title: Text("IBAN"),
                    subtitle: Text(quoteIBAN),
                  ),
                  //Spacer(),
                  ButtonBar(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.content_copy),
                        color: Colors.cyan,
                        onPressed: (){
                          Clipboard.setData(ClipboardData(text: quoteIBAN));
                          Fluttertoast.showToast(
                            msg: "IBAN Copié dans le presse-papier !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      ),
                    ],
                  ),

                  ListTile(
                    leading:Icon(Icons.credit_card),
                    title: Text("RIB"),
                    subtitle: Text(quoteSIREN),
                  ),
                  //Spacer(),
                  ButtonBar(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.content_copy),
                        color: Colors.cyan,
                        onPressed: (){
                          Clipboard.setData(ClipboardData(text: quoteRIB));
                          Fluttertoast.showToast(
                            msg: "RIB Copié dans le presse-papier !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      ),
                    ],
                  ),

                ],
              ),

        ),*/

/*body: Column(
          children: [
            Row(
              children: [
                Text("SIRET : XXXXXXXXXXXXXXX"),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.content_copy),
                  color: Colors.cyan,
                  onPressed: (){
                      Clipboard.setData(ClipboardData(text: quoteSIRET));
                      Fluttertoast.showToast(
                          msg: "SIRET Copié dans le presse-papier !",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                      );
                  },
                ),
              ]
            ),
            Row(
              children: [
                Text("SIREN : XXXXXXXXXXXXXXX"),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.content_copy),
                  color: Colors.cyan,
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: quoteSIREN));
                    Fluttertoast.showToast(
                        msg: "SIREN Copié dans le presse-papier !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("IBAN : FRXX XXXX XXXX XXXX XXXX XX"),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.content_copy),
                  color: Colors.cyan,
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: quoteIBAN));
                    Fluttertoast.showToast(
                        msg: "IBAN Copié dans le presse-papier !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("RIB : FRXX XXXX XXXX XXXX XXXX XX"),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.content_copy),
                  color: Colors.cyan,
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: quoteRIB));
                    Fluttertoast.showToast(
                        msg: "RIB Copié dans le presse-papier !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  },
                )
              ],
            ),

      /*ListView(children: <Widget>[
          ListTile(title: Text("SIRET : XXXXXXXXXXXXXXX"),),
          ListTile(title: Text("SIREN : XXXXXXXXXXXXXXX"),),
          ListTile(title: Text("IBAN : FRXX XXXX XXXX XXXX XXXX XX"),),
          ListTile(title: Text("RIB : FRXX XXXX XXXX XXXX XXXX XX"),)
        ]
      )*/
      ],
        ),*/
