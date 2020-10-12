import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class CardEsieePlus extends StatefulWidget {

  bool asPage;
  CardEsieePlus({this.asPage}) {
    this.asPage == null ? false : this.asPage = this.asPage;
  }

  @override
  State<StatefulWidget> createState() {
    return CardEsieePlusState();
  }
}

class CardEsieePlusState extends State<CardEsieePlus> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    widget.asPage ?
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]) : SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.asPage ?
    Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("https://www.dcube-paris.com/wp-content/uploads/2016/08/Esiee-850x554.jpg"),
                  ),
                ),
                child: Center(
                  child: _CardEsieePlus(),
                )
            ),
            Align(
              alignment: Alignment.centerRight,
              //right: 20,
              child: RawMaterialButton(
                onPressed: () { if(Navigator.canPop(context)) Navigator.pop(context); },
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.arrow_back,
                  size: 30.0,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
          ],
        )
    ) :
    _CardEsieePlus();
  }

  _CardEsieePlus() {
    double cardHeight = 650;
    double cardWidth = 1004;
    double angle = 12;
    double codeBarreH = cardHeight/4.5;
    double codeBarreW = cardWidth/2;
    double value = 0;
    if(MediaQuery.of(context).orientation == Orientation.portrait) {
      cardHeight = (MediaQuery.of(context).size.width-70)*0.6;
      cardWidth = MediaQuery.of(context).size.width-70;
      angle = 10;
      codeBarreH = cardHeight/4;
      codeBarreW = cardWidth/1.5;
      value = 10;
    }
    else {
      cardWidth = 495;
      cardHeight = 315;
      angle = 14;
      codeBarreH = (cardHeight/7)*1.5;
      codeBarreW = (cardWidth/2)*1.25;
      value = 20;
    }

    return Hero(
      tag: "cardESIEEPlus",
      child: Container(
        margin: EdgeInsets.symmetric(vertical: value),
        height: cardHeight,
        width: cardWidth,
        //color: Colors.white,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(angle),
          ),
          elevation: 3,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: value),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [MyTheme.PrimaryColorLight, MyTheme.SelectedColor],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    stops: [0,0.8]
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 5,
                    right: 0,
                    child:Container(
                      height: codeBarreH,
                      width: codeBarreW,
                      child: SfBarcodeGenerator(
                        symbology: Code39(),
                        barColor: Colors.white,
                        value: Base.thisUser.idStudent.toString(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: value,
                    child: Text(
                      "ID : " + Base.thisUser.idStudent.toString(),
                      style: TextStyle(color: Colors.white, fontSize: cardWidth/25, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Base.thisUser.firstname.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: cardWidth/15, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: cardWidth/150,),
                        Text(
                          Base.thisUser.lastname.substring(0, 1) + Base.thisUser.lastname.substring(1, Base.thisUser.lastname.length).toLowerCase(),
                          style: TextStyle(color: Colors.white, fontSize: cardWidth/15, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: cardWidth/150,),
                        Text(
                          Base.thisUser.promo.substring(3, Base.thisUser.promo.length),
                          style: TextStyle(color: Colors.white, fontSize: cardWidth/19, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 15,
                    child: Image(image: AssetImage('assets/esieeplus/white_LetterLogo.webp'), height: cardWidth/12, width: cardWidth/3, fit: BoxFit.fill),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }

}
