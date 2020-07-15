import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../../App.dart';

class EsieeCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    Orientation orientation = MediaQuery.of(context).orientation;
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage("https://www.dcube-paris.com/wp-content/uploads/2016/08/Esiee-850x554.jpg"),
            ),
          ),
          child: Center(
            child: Card(
              //color: PrimaryColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: Colors.black45,
                  width: 1.0,
                ),
              ),
              child: Container(
                height: orientation == Orientation.portrait ? 100 : 315,
                width: orientation == Orientation.portrait ? 100 : 495,
                child: Column(
                    children: <Widget>[
                      Container(
                        padding: orientation == Orientation.portrait ? EdgeInsets.all(0) : EdgeInsets.only(left: 30, top: 2),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image(image: NetworkImage("https://www.esiee.fr/sites/all/themes/custom/esiee_theme/logo.png")),
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  padding: EdgeInsets.only(left: 2, top: 2),
                                  height: orientation == Orientation.portrait ? 0 : 70,
                                  width: orientation == Orientation.portrait ? 0 : 175,
                                  child: Text(
                                    "L'école de\nl'innovation\ntechnologique".toUpperCase(),
                                    style: GoogleFonts.robotoCondensed(
                                      textStyle: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF44b3ea),
                                        height: 1,
                                        wordSpacing: 2,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xFF44b3ea).withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 2, top: 2),
                                    height: orientation == Orientation.portrait ? 0 : 70,
                                    width: orientation == Orientation.portrait ? 0 : 150,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("cité descartes\n2 bd blaise pascal - bp 99\n93162 noisy-le-grand cedex\nTél : 33 (0)1 45 92 65 00\n".toUpperCase()
                                            + "www.esiee.fr",
                                          style:  GoogleFonts.robotoCondensed(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.5,
                                              color: PrimaryColor,
                                              wordSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                            Container(
                              padding: orientation == Orientation.portrait ? EdgeInsets.all(0) : EdgeInsets.only(top: 5),
                              height: orientation == Orientation.portrait ? 100 : 190,
                              width: orientation == Orientation.portrait ? 100 : 500,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(bottom: 3),
                                        alignment: Alignment.bottomCenter,
                                        color: Color(0xFF002860),
                                        height: orientation == Orientation.portrait ? 100 : 35,
                                        width: orientation == Orientation.portrait ? 100 : 335,
                                        child: Text(
                                          Base.thisUser.promo.contains('F') ? "carte nationale d'apprenti".toUpperCase() : "carte étudiant".toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            height: 1,
                                            wordSpacing: 2,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(Base.thisUser.lastname,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(Base.thisUser.firstname,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("né le ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("BEA / INE : ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Expire le : 31/12/" +
                                            (DateTime.now().month <= 9 ?
                                            DateTime.now().year.toString() : (DateTime.now().year+1).toString()),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: orientation == Orientation.portrait ? EdgeInsets.all(0) : EdgeInsets.only(left: 10, top: 3, ),
                                    height: orientation == Orientation.portrait ? 100 : 135,
                                    width: orientation == Orientation.portrait ? 100 : 105,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(user.photoUrl),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 5,
                        width: 480,
                        color: Color(0xFF44b3ea),
                      ),
                      Container(
                        padding: orientation == Orientation.portrait ? EdgeInsets.all(0) : EdgeInsets.only(left: 30, top: 3),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget> [
                              Container(
                                padding: orientation == Orientation.portrait ? EdgeInsets.all(0) : EdgeInsets.only(bottom: 2),
                                height: orientation == Orientation.portrait ? 100 : 45,
                                width: orientation == Orientation.portrait ? 100 : 193,
                                child: SfBarcodeGenerator(
                                  value: Base.thisUser.idStudent.toString(),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Image(image: NetworkImage("https://www.gescia.fr/sites/default/files/thumbnails/image/logo_une%20ecole_de_la_ccipidf171px.png"), height: 30,),
                              )
                            ]
                        ),
                      ),
                    ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}