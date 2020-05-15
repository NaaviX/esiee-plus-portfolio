import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BdeInfos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String quoteSIRET = "XXXXXXXXXXXXXXX";
    String quoteSIREN = "XXXXXXXXXXXXXXX";
    String quoteIBAN = "FRXX XXXX XXXX XXXX XXXX XX";
    String quoteRIB = "FRXX XXXX XXXX XXXX XXXX XX";

    return Scaffold(
        appBar: AppBar(
          title: Text("Informations BDE"),
        ),

        body: Card(
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

        ),

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
    );
  }


}