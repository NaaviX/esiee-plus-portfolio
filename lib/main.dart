import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translations.dart';

void main() => runApp(App());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Application',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(Translations.of(context).text('main_title')),
        ),
        body: new Container(
        ),
      ),
    );
  }
}