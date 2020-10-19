import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {


  SplashScreen();

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    MyTheme.setStatusBarColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, appState, child)
        {
          return MaterialApp(
              theme: MyTheme.defaultTheme,
              darkTheme: MyTheme.darkTheme,
              themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode
                  .light,
              home: Scaffold(
                body: Center(
                  child: Image(image: AssetImage('assets/esieeplus/LogoFond.png'), height: 192,),
                ),

              )
          );
        }
    );
  }
}
