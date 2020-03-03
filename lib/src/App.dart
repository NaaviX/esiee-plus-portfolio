import 'package:bde_esiee_mobile/src/ui/club_list.dart';
import 'package:bde_esiee_mobile/src/ui/grades_list.dart';
import 'package:bde_esiee_mobile/src/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'ui/event_list.dart';
import 'ui/home.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'resources/translations.dart';

//so1Sw1nS

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  Widget app;
  @override
  void initState() {
    super.initState();
    if (user == null) {
        app = MaterialApp(home: LoginPage(),
            localizationsDelegates: [
              const TranslationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('fr', ''),
            ]);
    } else {
        app = MaterialApp(home: Base(),
            localizationsDelegates: [
              const TranslationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('fr', ''),
            ]);
    }
    }

  @override
  Widget build(BuildContext context) {
    //logs de l'aplication ex: Log.i("titre", "texte");
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    return app;
  }
}

class Base extends StatefulWidget {
  Base({Key key}) : super(key: key);

  @override
  _Base createState() => _Base();
}

class _Base extends State<Base> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    GradesList(),
    EventList(),
  ];

  static List<String> _selectedAppbarTitle;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedAppbarTitle = [
      Translations.of(context).text("bde"),
      Translations.of(context).text("edt"),
      Translations.of(context).text("events"),
    ];
    return Scaffold(
        appBar:
            AppBar(title: Text(_selectedAppbarTitle.elementAt(_selectedIndex))),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: getBottomNavigationBar(),
        drawer: getDrawer());
  }

  Widget getDrawer() {
    return Drawer(
        child: ListView(children: <Widget>[
      DrawerHeader(
        child: new Text(Translations.of(context).text("bde")),
        decoration: BoxDecoration(color: Colors.blueGrey),
      ),
          ListTile(
            title: new Text(Translations.of(context).text("deco")),
            onTap: () {
              signOutGoogle();
              user = null;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                _selectedIndex = 0;
                return App();
              }));
            },
          ),
      ListTile(
        title: new Text(Translations.of(context).text("clubs")),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            _selectedIndex = 0;
            return ClubList();
          }));
        },
      )
    ]));
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      items:  <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: new Text(Translations.of(context).text("home")),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          title: new Text(Translations.of(context).text("edt")),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          title: new Text(Translations.of(context).text("events")),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue[800],
      onTap: _onItemTapped,
    );
  }
}
