import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/calendar.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/calendar_controller.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/grade_list.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/grades_utils.dart';
import 'package:bde_esiee_mobile/src/ui/prof/class_document_upload.dart';
import 'package:bde_esiee_mobile/src/ui/prof/class_notification.dart';
import 'package:bde_esiee_mobile/src/ui/roles/Treasury/fairpay_manager.dart';
import 'package:bde_esiee_mobile/src/ui/roles/Treasury/treasury_dashboard.dart';
import 'package:bde_esiee_mobile/src/ui/roles/Treasury/treasury_manager.dart';
import 'package:bde_esiee_mobile/src/ui/settings.dart';
import 'package:bde_esiee_mobile/src/ui/student/annals.dart';
import 'package:bde_esiee_mobile/src/ui/roles/bde_infos.dart';
import 'package:bde_esiee_mobile/src/ui/student/class_document.dart';
import 'package:bde_esiee_mobile/src/ui/student/club_list.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_member_manager.dart';
import 'package:bde_esiee_mobile/src/ui/roles/event_manager.dart';
import 'package:bde_esiee_mobile/src/ui/club/fairpay.dart';
import 'package:bde_esiee_mobile/src/ui/student/free_rooms.dart';
import 'package:bde_esiee_mobile/src/ui/login_page.dart';
import 'package:bde_esiee_mobile/src/ui/messenger.dart';
import 'package:bde_esiee_mobile/src/ui/student/prof_list.dart';
import 'package:bde_esiee_mobile/src/ui/roles/stock.dart';
import 'package:bde_esiee_mobile/src/ui/roles/user_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'blocs/clubs_bloc.dart';
import 'models/prof_model.dart';
import 'ui/event/event_list.dart';
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
  final studentBloc = StudentsBloc();
  final clubsBloc = ClubsBloc();
  final profsBloc = ProfsBloc();

  StudentModel thisUser;
  ClubModel thisClub;
  ProfModel thisProf;

  final log = Logger('BASE');

  int _selectedIndex = 0;

  PageController pageController = PageController();



  List<Widget> _widgetOptions;

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
    profsBloc.fetchProf(user.email);


  }

  @override
  void dispose() {
    studentBloc.dispose();
    clubsBloc.dispose();
    profsBloc.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    log.fine("base");
    return StreamBuilder(
      stream: studentBloc.thisStudent,
      builder: (context, AsyncSnapshot<StudentModel> snapshot) {
        if (snapshot.hasData) {
          //isStudent
          log.fine("student");
          thisUser = snapshot.data;
          return _getApp();
        } else {
          //isClub
          return StreamBuilder(
            stream: clubsBloc.thisClub,
            builder: (context, AsyncSnapshot<ClubModel> snapshot) {
              if (snapshot.hasData) {
                log.fine("club");
                thisClub = snapshot.data;
                return _getApp();
              } else {
                //C'est un prof
                return StreamBuilder(
                  stream: profsBloc.thisProf,
                  builder: (context, AsyncSnapshot<ProfModel> snapshot) {
                    if (snapshot.hasData) {
                      log.fine("prof");
                      thisProf = snapshot.data;
                      return _getApp();
                    } else {
                      log.fine("loading");
                      return LoginPage();
                    }
                  },
                );
              }
            },
          );
        }
      },

    );
  }

  Widget _getApp() {
    _widgetOptions = <Widget>[
      Home(thisUser, thisClub, thisProf),
      CalendarController(),
      EventList(),
    ];
    return Scaffold(
        appBar:
        AppBar(title: Text(_selectedAppbarTitle.elementAt(_selectedIndex))),
        body: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: _widgetOptions,
        ),//_widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: getBottomNavigationBar(),
        drawer: _getDrawer());
  }

  Widget _getDrawer() {
    return Drawer(
        child: ListView(children: <Widget>[
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
            title: Text(user.displayName),
            subtitle: Text(user.email),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: new Text("Paramètres"),
            onTap: () {

              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return Settings();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new),
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


          _adminMenu(),
          _modoMenu(),
          _trezMenu(),
          _logMenu(),
          _clubMenu(),
          _studentMenu(),
          _profMenu()
        ]));
  }

  Widget _profMenu() {
    if (thisProf != null) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: user.displayName,
              style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16,)
          ),
        ),

        ListTile(
          leading: Icon(Icons.import_contacts),
          title: Text("Cours"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClassDocumentUpload();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.group),
          title: Text("Notification classe"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClassNotification();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.chat),
          title: Text("Messenger"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Messenger();
            }));
          },
        )
      ]);
    }
    return Column();
  }

  Widget _clubMenu() {
    if(thisClub!=null) {
      return Column(children : [
        Divider(),
        RichText(
          text: TextSpan(
              text: thisClub.name,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),

        ListTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text("Fairpay"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Fairpay(thisClub);
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.group_add),
          title: Text("Gestion des membres"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClubMemberManager(thisClub);
            }));
          },
        ),

        ListTile(
          leading: Icon(Icons.chat),
          title: Text("Messenger"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Messenger();
            }));
          },
        ),
      ]);
    }
    return Column();
  }

  Widget _studentMenu() {
    if (thisUser != null) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: thisUser.firstname,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),
        ListTile(
          leading: Icon(Icons.group),
          title: Text("Clubs"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClubList();
            }));
          },
        ),

        ListTile(
          leading: Icon(Icons.location_on),
          title: Text("Salles libres"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return FreeRooms();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.contacts),
          title: Text("Liste des professeurs"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProfList();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.import_contacts),
          title: Text("Cours"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClassDocument();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.class_),
          title: Text("Annales"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AnnalsList();
            }));
          },
        ),

        ListTile(
          leading: Icon(Icons.chat),
          title: Text("Messenger"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Messenger();
            }));
          },
        ),
      ]);
    }
    return Column();
  }


  Widget _adminMenu() {
    if (thisUser != null && thisUser.isAdmin) {
      return Column(children: [

        Divider(),
        RichText(
          text: TextSpan(
              text: 'Administration',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("Informations importantes"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BdeInfos();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.account_balance),
          title: Text("Dashboard trésorerie"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TreasuryDashboard();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.group_add),
          title: Text("Droits utilisateurs"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return UserPermissions();
            }));
          },
        )
      ]);
    }
    return Column();
  }

  Widget _modoMenu() {
    if (thisUser != null && thisUser.isModo) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Modération',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text("Gestion évènements"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EventManager();
            }));
          },
        )
      ]);
    }
    return Column();
  }

  Widget _trezMenu() {
    if (thisUser != null && thisUser.isTrez) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Trésorerie',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),
        ListTile(
          leading: Icon(Icons.euro_symbol),
          title: Text("Gestion trésorerie"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TreasuryManager();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.equalizer),
          title: Text("Gestion Fairpay"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return FairPayManager();
            }));
          },
        )
      ]);
    }
    return Column();
  }
  Widget _logMenu() {
    if (thisUser != null && thisUser.isLog) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Logistique',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, )
          ),
        ),

        ListTile(
          leading: Icon(Icons.local_grocery_store),
          title: Text("Réserve"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Stock();
            }));
          },
        )
      ]);
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
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue[800],
      onTap: _onItemTapped,
    );
  }

}
