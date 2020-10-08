import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/calendar.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/ColorMean.dart';
import 'package:bde_esiee_mobile/src/ui/messenger/messenger_history.dart';
import 'package:bde_esiee_mobile/src/ui/prof/class_document_upload.dart';
import 'package:bde_esiee_mobile/src/ui/prof/class_notification.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_add.dart';
import 'package:bde_esiee_mobile/src/ui/prof/units_list.dart';
import 'package:bde_esiee_mobile/src/ui/profile.dart';
import 'package:bde_esiee_mobile/src/ui/roles/admin/contributor_manager.dart';
import 'package:bde_esiee_mobile/src/ui/roles/contributor_verificator.dart';
import 'package:bde_esiee_mobile/src/ui/roles/trez/fairpay_manager.dart';
import 'package:bde_esiee_mobile/src/ui/roles/trez/treasury_manager.dart';
import 'package:bde_esiee_mobile/src/ui/student/club_list.dart';
import 'package:bde_esiee_mobile/src/ui/club/club_member_manager.dart';
import 'package:bde_esiee_mobile/src/ui/event/event_manager.dart';
import 'package:bde_esiee_mobile/src/ui/roles/trez/club_fairpay.dart';
import 'package:bde_esiee_mobile/src/ui/student/esiee_card.dart';
import 'package:bde_esiee_mobile/src/ui/student/free_rooms.dart';
import 'package:bde_esiee_mobile/src/ui/login_page.dart';
import 'package:bde_esiee_mobile/src/ui/roles/log/stock.dart';
import 'package:bde_esiee_mobile/src/ui/roles/admin/user_permissions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'blocs/clubs_bloc.dart';
import 'blocs/jwt_bloc.dart';
import 'blocs/roles_bloc.dart';
import 'forceUpdate.dart';
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
  final jwtBloc = JwtBloc();


  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: MyTheme.LightBackground,
          systemNavigationBarDividerColor: Colors.transparent,
        )
    );
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
            //google user is logged in
            return JwtAuth();

          } else {
//user not logged in
            return MaterialApp(
              theme: MyTheme.defaultTheme,
              //theme : MyTheme.darkTheme,
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
        });
  }
}

class JwtAuth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JwtAuthState();
  }
}
class JwtAuthState extends State<JwtAuth> {
  final jwtBloc = JwtBloc();

  @override
  void initState() {
    jwtBloc.authenticate(user.email, user.uid);
  }


  @override
  void dispose() {
    jwtBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: jwtBloc.token,
        builder: (context, AsyncSnapshot<String> snapshot)
        {
          print("connection state jwt ${snapshot.connectionState}");
          if (snapshot.hasData) {
            print("hasdate");
            Base.token = snapshot.data;
            return MaterialApp(
              theme: MyTheme.defaultTheme,
              //theme : MyTheme.darkTheme,
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
            print("hasNotdate");
            return MaterialApp(
              theme: MyTheme.defaultTheme,
              //theme : MyTheme.darkTheme,
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
  static String token;

  @override
  _Base createState() => _Base();
}

class _Base extends State<Base> {
  final studentBloc = StudentsBloc();
  final clubsBloc = ClubsBloc();
  final profsBloc = ProfsBloc();
  RolesBloc rolesBloc = RolesBloc();

  final log = Logger('BASE');

  PageController pageController =
  PageController(initialPage: Base.selectedIndex);

  List<Widget> _widgetOptions;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static List<Widget> _selectedAppbarTitleWidget = [
    Center(
      child: Image(image: AssetImage('assets/esieeplus/color_LetterLogo.webp'), height: 25, width: 100, fit: BoxFit.fill),
    ),
    Text('Emploi du temps'),
    Text('Evenements'),
  ];

  List<Widget> actionButton() {
    ColorDetect c = ColorDetect(user.photoUrl);
    if (Base.selectedIndex == 0) {
      return [
        FutureBuilder(
            future: c.getColor(),
            builder: (_, AsyncSnapshot<Color> data){
              if (data.connectionState==ConnectionState.done) {
                Color color = data.data;
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile(color)
                  ),
                ),
              child: Container(
              //padding: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Hero(
              tag: "photo",
              child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 20,
              )),
              /*Image.asset(
            'assets/esieeplus/Logo.webp',
          ),*/
              ),
              );
              }
              return CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 20,
              );
            }),
        SizedBox(
          width: 20,
        )
      ];
    }
    else if (Base.selectedIndex == 1) {
      return [
        IconButton(
          icon: const Icon(Icons.info_outline),
          padding: EdgeInsets.all(5),
          onPressed: () {
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text("ESIEE+ ne peut être tenu responsable des erreurs eventuelles de l'agenda.", textAlign: TextAlign.justify),
                  backgroundColor: Colors.blueAccent,
                )
            );
          },
        ),
        /*IconButton(
          icon: const Icon(Icons.today),
          padding: EdgeInsets.all(2),
          onPressed: () {
            pageController.jumpToPage(1);
          },
        ),*/
        SizedBox(
          width: 10,
        )
      ];
    }
    else return null;
  }

  Future<bool> isInternetConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
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
                            signOutGoogle();
                            log.fine("loading");
                            return Container(
                              color: Theme.of(context).backgroundColor,
                              child: LoginPage(),
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
      Calendar(),
      EventList(),
    ];
    if(Base.thisUser == null) _widgetOptions.removeAt(1);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.dehaze, size: 30,),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            brightness: Brightness.light,
            title: _selectedAppbarTitleWidget.elementAt(Base.selectedIndex),//Text(_selectedAppbarTitle.elementAt(Base.selectedIndex)),
            actions: actionButton()),
        body: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: _widgetOptions,
        ),
        bottomNavigationBar: getBottomNavigationBar(),
        drawer: _getDrawer());
  }

  Widget _getDrawer() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return false;
      },
      child: Container(
        width: 270,
        color: Theme.of(context).backgroundColor,
        child: Drawer(
          elevation: 20,
          child: ListView(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15, left: 15, bottom: 5),
              height: 40,
              child : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Image(image: AssetImage('assets/esieeplus/Logo.webp'), width: 35),
                  SizedBox(width: 15,),
                  Image(image: AssetImage('assets/esieeplus/primary_LetterLogo.webp'), height: 25, width: 100, fit: BoxFit.fill),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new, color: Theme.of(context).primaryColor.withOpacity(0.8)),
              title: new Text(Translations.of(context).text("deco"), style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),),
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
          ]),
        ),
      ),
    );
  }

  Widget _MenuTitle() {
    return Divider(height: 1, thickness: 1.5, color: Colors.black12,);
    /*return Container(
      margin: EdgeInsets.all(30),
      child: RichText(
        text: TextSpan(
            text: type ?? user.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            )),
      ),
    );*/
  }

  Widget _MenuElmt(IconData icon, String title, Widget route) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      leading: Icon(icon, color: Theme.of(context).primaryColor.withOpacity(0.8)),
      title: Text(title, style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return route;
        }));
      },
    );
  }

  Widget _requireConnectionTile(IconData icon, String title, Widget route) {
    return FutureBuilder(
        future: isInternetConnected(),
        builder: (BuildContext context, AsyncSnapshot<bool> connected) {
          return connected.hasData && connected.data
              ? _MenuElmt(icon, title, route)
              : ListTile(
              leading: Icon(icon, color: Colors.grey),
              title: Text(
                title,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text("Non disponible hors connexion"),
                  backgroundColor: Colors.grey,
                ));
                Navigator.pop(context);
              });
        });
  }

  Widget _profMenu() {
    if (Base.thisProf != null) {
      return Column(children: [
        _MenuTitle(),
        _MenuElmt(Icons.import_contacts, "Cours", ClassDocumentUpload()),
        _MenuElmt(Icons.group, "Notification Classe", ClassNotification()),
        _MenuElmt(Icons.chat, "Messenger", MessengerHistory()),
      ]);
    }
    return Column();
  }

  Widget _clubMenu() {
    if (Base.thisClub != null) {
      return Column(children: [
        _MenuTitle(),
        _MenuElmt(Icons.account_balance_wallet, "Mon Fairpay", Fairpay()),
        _MenuElmt(Icons.group_add, "Gestion des Membres", ClubMemberManager()),
        _MenuElmt(Icons.chat, "Messenger", MessengerHistory()),
      ]);
    }
    return Column();
  }

  Widget _studentMenu() {
    if (Base.thisUser != null) {
      return Column(children: [
        _MenuTitle(),
        //_MenuElmt(Icons.credit_card, "Ma carte", EsieeCard()),
        _MenuElmt(Icons.group, "Clubs", ClubList()),
        _requireConnectionTile(Icons.location_on, "Salles Libres", FreeRooms()),
        _MenuElmt(Icons.contacts, "Liste des Professeurs", UnitsList()),
        //_MenuElmt(Icons.import_contacts, "Cours", ClassDocument()),
        //_MenuElmt(Icons.class_, "Annales", AnnalsList()),
        //_MenuElmt(Icons.chat, "Messenger", MessengerHistory()),
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
        _MenuTitle(),
        //_MenuElmt(Icons.info_outline, "Informations importantes", BdeInfos()),
        _MenuElmt(Icons.beenhere, "Ajout Cotisants", ContributorManager()),
        //_MenuElmt(Icons.account_balance, "Dashboard trésorerie", TreasuryDashboard()),
        _requireConnectionTile(Icons.group_add, "Droits Utilisateurs", UserPermissions())
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
        _MenuTitle(),
        _requireConnectionTile(Icons.date_range, "Gestion Evènements", EventManager()),
        _requireConnectionTile(Icons.verified_user, "Cotisants", ContributorVerificator()),
        _requireConnectionTile(Icons.person_add, "Ajout Professeur", AddProf())
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
        _MenuTitle(),
        _MenuElmt(Icons.euro_symbol, "Gestion Trésorerie", TreasuryManager()),
        _MenuElmt(Icons.equalizer, "Gestion Fairpay", FairPayManager()),
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
        _MenuTitle(),
        _MenuElmt(Icons.local_grocery_store, "Réserve", Stock()),
      ]);
    }
    return Column();
  }

  Widget getBottomNavigationBar() {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.home,),
        activeIcon: Icon(FontAwesomeIcons.home, color: Theme.of(context).primaryColor,),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.clock,),
        activeIcon: Icon(FontAwesomeIcons.clock, color: Theme
            .of(context)
            .primaryColor,),
        title: Text('EDT'),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.calendarAlt,),
        activeIcon: Icon(FontAwesomeIcons.calendarAlt, color: Theme.of(context).primaryColor,),
        title: Text('Event',),
      ),
    ];
    if(Base.thisUser == null ) items.removeAt(1);
    return BottomNavigationBar(
      items: items,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: Base.selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: _onItemTapped,
    );
  }
}
