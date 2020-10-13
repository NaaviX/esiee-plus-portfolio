import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashScreen extends StatefulWidget {


  SplashScreen();

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Image(image: AssetImage('assets/esieeplus/LogoFond.webp'), width: 150),
                      elevation: 5,
                    ),
                  ],
                ),
              ),
            ),
          ]
      ),
    ));
  }
}
