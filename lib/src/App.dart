import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/annals.dart';
import 'package:bde_esiee_mobile/src/ui/bde_infos.dart';
import 'package:bde_esiee_mobile/src/ui/class_document.dart';
import 'package:bde_esiee_mobile/src/ui/club_list.dart';
import 'package:bde_esiee_mobile/src/ui/club_member_manager.dart';
import 'package:bde_esiee_mobile/src/ui/event_manager.dart';
import 'package:bde_esiee_mobile/src/ui/fairpay.dart';
import 'package:bde_esiee_mobile/src/ui/fairpay_manager.dart';
import 'package:bde_esiee_mobile/src/ui/free_rooms.dart';
import 'package:bde_esiee_mobile/src/ui/grades_list.dart';
import 'package:bde_esiee_mobile/src/ui/login_page.dart';
import 'package:bde_esiee_mobile/src/ui/messenger.dart';
import 'package:bde_esiee_mobile/src/ui/prof_list.dart';
import 'package:bde_esiee_mobile/src/ui/stock.dart';
import 'package:bde_esiee_mobile/src/ui/treasury_dashboard.dart';
import 'package:bde_esiee_mobile/src/ui/treasury_manager.dart';
import 'package:bde_esiee_mobile/src/ui/user_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'blocs/clubs_bloc.dart';
import 'models/club_model.dart';
import 'models/role_model.dart';
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

class _Base extends State<Base>  {
  final studentBloc = StudentsBloc();
  final clubsBloc = ClubsBloc();

  static dynamic thisUser;
  static dynamic thisClub;

  final log = Logger('BASE');

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Home(thisUser, thisClub),
    GradesList(),
    EventList(),
  ];

  static List<String> _selectedAppbarTitle = [
    'BDE ESIEE Paris',
    'Emploi du temps',
    'Evenements',
  ];

  @override
  void initState() {
    super.initState();
    studentBloc.fetchStudent(user.email);
    clubsBloc.fetchClub(user.email);
  }

  @override
  void dispose() {
    studentBloc.dispose();
    clubsBloc.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: studentBloc.thisStudent,
      builder: (context, AsyncSnapshot<StudentModel> snapshot) {
        if (snapshot.hasData) {
          //isStudent
          thisUser = snapshot.data;
          return _getApp();
        } else {
          //isClub
          return StreamBuilder(
            stream: clubsBloc.thisClub,
            builder: (context, AsyncSnapshot<ClubModel> snapshot) {
              if (snapshot.hasData) {
                thisClub = snapshot.data;
                return _getApp();
              } else {
                //C'est un prof
                return Column();
              }
            },
          );

        }


      },

    );

  }

  Widget _getApp() {
    return Scaffold(
        appBar:
        AppBar(title: Text(_selectedAppbarTitle.elementAt(_selectedIndex))),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: getBottomNavigationBar(),
        drawer: _getDrawer());
  }

  Widget _getDrawer() {
    return Drawer(
        child: ListView(children: <Widget>[

          ListTile(
            leading: CircleAvatar(backgroundImage:  NetworkImage(user.photoUrl)),
            title: Text(user.displayName),
            subtitle: Text(user.email),
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
          Divider(),
          ListTile(
            title: Text("Clubs"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ClubList();
              }));
            },
          ),
          _clubMenu(),
          _studentMenu(),
          //_profMenu(),
          _adminMenu(),
          _modoMenu(),
          _trezMenu(),
          _logMenu()
        ]));
  }


  Widget _clubMenu() {
    if(thisClub!=null) {
      return Column(children : [
        Divider(),
        RichText(
          text: TextSpan(
              text: thisClub.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),

        ListTile(
          title: Text("Fairpay"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Fairpay();
            }));
          },
        ),
        ListTile(
          title: Text("Gestion des membres"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClubMemberManager();
            }));
          },
        ),

        ListTile(
          title: Text("Messenger"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Messenger();
            }));
          },
        ),]);
    }
    return Column();
  }

  Widget _studentMenu() {
    if(thisUser!=null) {
      return Column(children : [
        Divider(),
        RichText(
          text: TextSpan(
              text: thisUser.firstname,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),

        ListTile(
          title: Text("Salles libres"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return FreeRooms();
            }));
          },
        ),
        ListTile(
          title: Text("Liste des professeurs"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProfList();
            }));
          },
        ),
        ListTile(
          title: Text("Cours"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClassDocument();
            }));
          },
        ),
        ListTile(
          title: Text("Annales"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Annals();
            }));
          },
        ),

        ListTile(
          title: Text("Messenger"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Messenger();
            }));
          },
        ),]);
    }
    return Column();
  }


  Widget _adminMenu() {
    if(thisUser!=null && thisUser.isAdmin) {
      return Column(children : [

        Divider(),
        RichText(
          text: TextSpan(
              text: 'Administration',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),
        ListTile(
          title: Text("Informations importantes"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BdeInfos();
            }));
          },
        ),
        ListTile(
          title: Text("Dashboard trésorerie"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TreasuryDashboard();
            }));
          },
        ),
        ListTile(
          title: Text("Droits utilisateurs"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return UserPermissions();
            }));
          },
        )]);
    }
    return Column();





  }

  Widget _modoMenu() {
    if(thisUser!=null && thisUser.isModo) {
      return Column(children : [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Modération',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),
        ListTile(
          title: Text("Gestion évènements"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EventManager();
            }));
          },
        )]);
    }
    return Column();
  }

  Widget _trezMenu() {
    if(thisUser!=null  && thisUser.isTrez) {
      return Column(children : [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Trésorerie',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),
        ListTile(
          title: Text("Gestion trésorerie"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TreasuryManager();
            }));
          },
        ),
        ListTile(
          title: Text("Gestion Fairpay"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return FairpayManager();
            }));
          },
        )]);
    }
    return Column();
  }
  Widget _logMenu() {
    if(thisUser!=null  && thisUser.isLog) {
      return Column(children : [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Logistique',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),

        ListTile(
          title: Text("Réserve"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Stock();
            }));
          },
        )]);
    }
    return Column();
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          title: Text('EDT'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          title: Text('Event'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue[800],
      onTap: _onItemTapped,
    );
  }

}
