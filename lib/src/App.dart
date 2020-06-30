import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/calendar_controller.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/grades/grade_list.dart';
import 'package:bde_esiee_mobile/src/ui/messenger/messenger_history.dart';
import 'package:bde_esiee_mobile/src/ui/prof/class_document_upload.dart';
import 'package:bde_esiee_mobile/src/ui/prof/class_notification.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_add.dart';
import 'package:bde_esiee_mobile/src/ui/prof/units_list.dart';
import 'package:bde_esiee_mobile/src/ui/roles/admin/contributor_manager.dart';
import 'package:bde_esiee_mobile/src/ui/roles/trez/fairpay_manager.dart';
import 'package:bde_esiee_mobile/src/ui/roles/trez/treasury_dashboard.dart';
import 'package:bde_esiee_mobile/src/ui/roles/trez/treasury_manager.dart';
import 'package:bde_esiee_mobile/src/ui/settings.dart';
import 'package:bde_esiee_mobile/src/ui/roles/admin/bde_infos.dart';
import 'package:bde_esiee_mobile/src/ui/student/annals.dart';
import 'package:bde_esiee_mobile/src/ui/student/class_document.dart';
import 'package:bde_esiee_mobile/src/ui/student/club_list.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_member_manager.dart';
import 'package:bde_esiee_mobile/src/ui/event/event_manager.dart';
import 'package:bde_esiee_mobile/src/ui/roles/trez/club_fairpay.dart';
import 'package:bde_esiee_mobile/src/ui/student/free_rooms.dart';
import 'package:bde_esiee_mobile/src/ui/login_page.dart';
import 'file:///C:/Users/mchanteloup/Desktop/bde_esiee_mobile/lib/src/ui/prof/prof_list.dart';
import 'package:bde_esiee_mobile/src/ui/roles/log/stock.dart';
import 'package:bde_esiee_mobile/src/ui/roles/admin/user_permissions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'blocs/clubs_bloc.dart';
import 'blocs/roles_bloc.dart';
import 'models/club_model.dart';
import 'models/prof_model.dart';
import 'models/role_model.dart';
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
  Widget build(BuildContext context) {
    //logs de l'aplication ex: Log.i("titre", "texte");
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
            //user is logged in
            return MaterialApp(
              theme : MyTheme.defaultTheme,
              //darkTheme : MyTheme.darkTheme,
              home: Base(),
              localizationsDelegates: [
                const TranslationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', ''),
                const Locale('fr', ''),
              ],
            );
          } else {
//user not logged in
            return MaterialApp(
              theme : MyTheme.defaultTheme,
              //darkTheme : MyTheme.darkTheme,
              home: LoginPage(),
              localizationsDelegates: [
                const TranslationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', ''),
                const Locale('fr', ''),
              ],
            );
          }
        }
    );
  }
}

class Base extends StatefulWidget {
  static int selectedIndex = 0;
  static List<RoleModel> allRoles;
  static StudentModel thisUser;
  static ClubModel thisClub;
  static ProfModel thisProf;
  @override
  _Base createState() => _Base();
}

class _Base extends State<Base> {
  final studentBloc = StudentsBloc();
  final clubsBloc = ClubsBloc();
  final profsBloc = ProfsBloc();
  RolesBloc rolesBloc = RolesBloc();

  final log = Logger('BASE');

  PageController pageController = PageController(initialPage: Base.selectedIndex);

  List<Widget> _widgetOptions;

  static List<String> _selectedAppbarTitle = [
    'BDE ESIEE Paris',
    'Emploi du temps',
    'Evenements',
  ];

  List<Widget> actionButton(BuildContext context) {
    if(Base.selectedIndex == 1) {
      return [
        /*IconButton(
          icon: const Icon(Icons.event),
          onPressed: () {
          },
        ),*/
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GradesList()),
            );
          },
        ),
      ];
    }
    else return null;
  }

  @override
  void initState() {
    rolesBloc.fetchAllRoles();
    studentBloc.fetchStudent(user.email);
    clubsBloc.fetchClub(user.email);
    profsBloc.fetchProf(user.email);
    super.initState();
  }

  @override
  void dispose() {
    rolesBloc.dispose();
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
      Base.selectedIndex = index;
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
        stream: rolesBloc.allRoles,
        builder: (context, AsyncSnapshot<List<RoleModel>> roleSnapshot) {
          Base.allRoles = roleSnapshot.data;
          return StreamBuilder(
            stream: studentBloc.thisStudent,
            builder: (context, AsyncSnapshot<StudentModel> snapshot) {
              print("connection state student ${snapshot.connectionState}");
              if (snapshot.hasData) {
                //isStudent
                log.fine("student");
                Base.thisUser = snapshot.data;
                return _getApp();
              } else {
                //isClub
                return StreamBuilder(
                  stream: clubsBloc.thisClub,
                  builder: (context, AsyncSnapshot<ClubModel> snapshot) {
                    print("connection state club ${snapshot.connectionState}");
                    if (snapshot.hasData) {
                      log.fine("club");
                      Base.thisClub = snapshot.data;
                      return _getApp();
                    } else {
                      //C'est un prof
                      return StreamBuilder(
                        stream: profsBloc.thisProf,
                        builder: (context, AsyncSnapshot<ProfModel> snapshot) {
                          print(
                              "connection state prof ${snapshot.connectionState}");
                          if (snapshot.hasData) {
                            log.fine("prof");
                            Base.thisProf = snapshot.data;
                            return _getApp();
                          } else {
                            log.fine("loading");
                            return Container(
                                color: Background,
                                child: LoginPage(withoutButton: true),
                          );//Center(child: Text("Loading"));//new CircularProgressIndicator());
                        }
                        },
                      );
                    }
                  },
                );
              }
            },
          );
        });
  }

  Widget _getApp() {
    _widgetOptions = <Widget>[
      Home(),
      CalendarController(),
      EventList(),
    ];
    return Scaffold(
        appBar:
        AppBar(title: Text(_selectedAppbarTitle.elementAt(Base.selectedIndex)), actions: actionButton(context)),
        body: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: _widgetOptions,
        ),
        bottomNavigationBar: getBottomNavigationBar(),
        drawer: _getDrawer());
  }

  Widget _getDrawer() {
    return Drawer(
        child: ListView(children: <Widget>[
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
            title: Text(user.displayName, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(user.email),
          ),
          /*ListTile(
            leading: Icon(Icons.settings),
            title: new Text("Paramètres"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Settings();
              }));
            },
          ),*/
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: new Text(Translations.of(context).text("deco")),
            onTap: () async {
              Navigator.of(context).pop();
              signOutGoogle();
              Base.selectedIndex = 0;
            },
          ),
          _adminMenu(),
          _modoMenu(),
          _trezMenu(),
          _logMenu(),
          _clubMenu(),
          _studentMenu(),
          _profMenu(),
        ]));
  }

  Widget _profMenu() {
    if (Base.thisProf != null) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: user.displayName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              )),
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
              return MessengerHistory();
            }));
          },
        )
      ]);
    }
    return Column();
  }

  Widget _clubMenu() {
    if (Base.thisClub != null) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: Base.thisClub.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              )),
        ),
        ListTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text("Fairpay"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Fairpay();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.group_add),
          title: Text("Gestion des membres"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClubMemberManager();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.chat),
          title: Text("Messenger"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MessengerHistory();
            }));
          },
        ),
      ]);
    }
    return Column();
  }

  Widget _studentMenu() {
    if (Base.thisUser != null) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: Base.thisUser.firstname,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              )),
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
              return UnitsList();
            }));
          },
        ),
        /*ListTile(
          leading: Icon(Icons.import_contacts),
          title: Text("Cours"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClassDocument();
            }));
          },
        ),*/
        /*ListTile(
          leading: Icon(Icons.class_),
          title: Text("Annales"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AnnalsList(); //AnnalsList();
            }));
          },
        ),*/
        ListTile(
          leading: Icon(Icons.chat),
          title: Text("Messenger"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MessengerHistory();
            }));
          },
        ),
      ]);
    }
    return Column();
  }

  Widget _adminMenu() {
    if (Base.thisUser != null &&
        Base.thisUser.roles.contains(
            Base.allRoles.firstWhere((element) => element.role == Role.admin)) ||
        Base.thisClub != null &&
            Base.thisClub.roles.contains(
                Base.allRoles.firstWhere((element) => element.role == Role.admin))) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Administration',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              )),
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
          leading: Icon(Icons.verified_user),
          title: Text("Cotisants"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ContributorManager();
            }));
          },
        ),
        /*ListTile(
          leading: Icon(Icons.account_balance),
          title: Text("Dashboard trésorerie"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TreasuryDashboard();
            }));
          },
        ),*/
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
    if (Base.thisUser != null &&
        Base.thisUser.roles.contains(
            Base.allRoles.firstWhere((element) => element.role == Role.mod)) ||
        Base.thisClub != null &&
            Base.thisClub.roles.contains(
                Base.allRoles.firstWhere((element) => element.role == Role.mod))) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Modération',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              )),
        ),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text("Gestion évènements"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EventManager();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.person_add),
          title: Text("Ajout professeur"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddProf();
            }));
          },
        ),
      ]);
    }
    return Column();
  }

  Widget _trezMenu() {
    if (Base.thisUser != null &&
        Base.thisUser.roles.contains(
            Base.allRoles.firstWhere((element) => element.role == Role.trez)) ||
        Base.thisClub != null &&
            Base.thisClub.roles.contains(
                Base.allRoles.firstWhere((element) => element.role == Role.trez))) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Trésorerie',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              )),
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
    if (Base.thisUser != null &&
        Base.thisUser.roles.contains(
            Base.allRoles.firstWhere((element) => element.role == Role.log)) ||
        Base.thisClub != null &&
            Base.thisClub.roles.contains(
                Base.allRoles.firstWhere((element) => element.role == Role.log))) {
      return Column(children: [
        Divider(),
        RichText(
          text: TextSpan(
              text: 'Logistique',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              )),
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
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.home,),
          activeIcon: Icon(FontAwesomeIcons.home, color: PrimaryColor,),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.clock,),
          activeIcon: Icon(FontAwesomeIcons.clock, color: PrimaryColor,),
          title: Text('EDT'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.calendarAlt,),
          activeIcon: Icon(FontAwesomeIcons.calendarAlt, color: PrimaryColor,),
          title: Text('Event',),
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: Base.selectedIndex,
      selectedItemColor: PrimaryColor,
      onTap: _onItemTapped,
    );
  }
}
