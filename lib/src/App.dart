import 'package:bde_esiee_mobile/src/blocs/jwt_event.dart';
import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/resources/Fairpay/fairpay_log_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/Fairpay/fairpay_log_repository.dart';
import 'package:bde_esiee_mobile/src/resources/club_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/club_repository.dart';
import 'package:bde_esiee_mobile/src/resources/event_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/event_repository.dart';
import 'package:bde_esiee_mobile/src/resources/free_rooms_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/free_rooms_repository.dart';
import 'package:bde_esiee_mobile/src/resources/jwt_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/jwt_repository.dart';
import 'package:bde_esiee_mobile/src/resources/prof_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/prof_repository.dart';
import 'package:bde_esiee_mobile/src/resources/role_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/role_repository.dart';
import 'package:bde_esiee_mobile/src/resources/stock_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/stock_repository.dart';
import 'package:bde_esiee_mobile/src/resources/student_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/student_repository.dart';
import 'package:bde_esiee_mobile/src/resources/unit_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/unit_repository.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/calendar/calendar.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/Color.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/KeeAlivePage.dart';
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
import 'package:bde_esiee_mobile/src/ui/splash_screen.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'blocs/club_event.dart';
import 'blocs/club_state.dart';
import 'blocs/clubs_bloc.dart';
import 'blocs/events_bloc.dart';
import 'blocs/fairpay_log_bloc.dart';
import 'blocs/free_rooms_bloc.dart';
import 'blocs/jwt_bloc.dart';
import 'blocs/jwt_state.dart';
import 'blocs/prof_event.dart';
import 'blocs/prof_state.dart';
import 'blocs/roles_bloc.dart';
import 'blocs/roles_event.dart';
import 'blocs/roles_state.dart';
import 'blocs/stock_bloc.dart';
import 'blocs/student_event.dart';
import 'blocs/student_state.dart';
import 'blocs/unit_bloc.dart';
import 'forceUpdate.dart';
import 'models/club_model.dart';
import 'models/event_model.dart';
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
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    MyTheme.SetStatusBarColor(context);
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
            final JwtRepository jwtRepository = JwtRepository(
              jwtApiProvider: JwtApiProvider(
                client: Client(),
              ),
            );
            return BlocProvider<JwtBloc>(
                create: (BuildContext context) =>
                    JwtBloc(jwtRepository: jwtRepository),
                child: JwtAuth());
          } else {
//user not logged in
            return Consumer<AppStateNotifier>(
                builder: (context, appState, child) {
                  return MaterialApp(
                    theme: MyTheme.defaultTheme,
                    darkTheme: MyTheme.darkTheme,
                    themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode
                        .light,
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
            );
          }
        }
    );
  }
}

class JwtAuth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JwtAuthState();
  }
}

class JwtAuthState extends State<JwtAuth> {
  @override
  void initState() {
    BlocProvider.of<JwtBloc>(context)
        .add(JwtAuthenticate(username: user.email, password: user.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JwtBloc, JwtState>(builder: (context, state) {
      if (state is JwtAuthenticateInitial) {
        return SplashScreen();
      }
      if (state is JwtAuthenticateInProgress) {
        return SplashScreen();
      }
      if (state is JwtAuthenticateSuccess) {
        Base.token = state.token;
        final RoleRepository roleRepository = RoleRepository(
          roleApiProvider: RoleApiProvider(
            client: Client(),
          ),
        );
        final StudentRepository studentRepository = StudentRepository(
          studentApiProvider: StudentApiProvider(
            client: Client(),
          ),
        );
        final ClubRepository clubRepository = ClubRepository(
          clubApiProvider: ClubApiProvider(
            client: Client(),
          ),
        );
        final ProfRepository profRepository = ProfRepository(
          profApiProvider: ProfApiProvider(
            client: Client(),
          ),
        );

        return Consumer<AppStateNotifier>(
            builder: (context, appState, child) {
              return
                MaterialApp(
                  theme: MyTheme.defaultTheme,
                  darkTheme: MyTheme.darkTheme,
                  themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  home: MultiBlocProvider(providers: [
                    BlocProvider<RolesBloc>(
                      create: (BuildContext context) =>
                          RolesBloc(roleRepository: roleRepository),
                    ),
                    BlocProvider<StudentsBloc>(
                      create: (BuildContext context) =>
                          StudentsBloc(studentRepository: studentRepository),
                    ),
                    BlocProvider<ClubsBloc>(
                      create: (BuildContext context) =>
                          ClubsBloc(clubRepository: clubRepository),
                    ),
                    BlocProvider<ProfsBloc>(
                      create: (BuildContext context) =>
                          ProfsBloc(profRepository: profRepository),
                    ),
                  ], child: UserAuth()),
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
        );
      }
      if (state is JwtAuthenticateFailure) {
        return Consumer<AppStateNotifier>(
            builder: (context, appState, child) {
              return
                MaterialApp(
                  theme: MyTheme.defaultTheme,
                  darkTheme: MyTheme.darkTheme,
                  themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
        );
      }
      return Container();
    });
  }
}

class UserAuth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserAuthState();
  }
}

class UserAuthState extends State<UserAuth> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RolesBloc>(context).add(RolesRequested());
    BlocProvider.of<StudentsBloc>(context)
        .add(StudentRequested(email: user.email));
    BlocProvider.of<ClubsBloc>(context).add(ClubsRequested());
    BlocProvider.of<ProfsBloc>(context).add(ProfRequested(mail: user.email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RolesBloc, RolesState>(builder: (context, state) {
      if (state is RolesInitial) {
        return SplashScreen();
      }
      if (state is RolesLoadInProgress) {
        return SplashScreen();
      }
      if (state is RolesLoadSuccess) {
        Base.allRoles = state.roles;
        return BlocBuilder<ClubsBloc, ClubState>(
          builder: (context, state) {
            if (state is ClubsInitial) {
              return SplashScreen();
            }
            if (state is ClubsLoadInProgress) {
              return SplashScreen();
            }
            if (state is ClubsLoadSuccess) {
              //isStudent
              log.fine("club");
              Base.allClubs = state.clubs;
              try {
                Base.thisClub = state.clubs
                    .firstWhere((element) => element.mail == user.email);
              } catch (_) {
                return BlocBuilder<StudentsBloc, StudentState>(
                  builder: (context, state) {
                    if (state is StudentInitial) {
                      return SplashScreen();
                    }
                    if (state is StudentLoadInProgress) {
                      return SplashScreen();
                    }
                    if (state is StudentLoadSuccess) {
                      //isStudent
                      log.fine("student");
                      Base.thisUser = state.student;
                      return Base();
                    }
                    if (state is StudentLoadFailure) {
                      //C'est un prof
                      return BlocBuilder<ProfsBloc, ProfState>(
                          builder: (context, state) {
                            if (state is ProfInitial) {
                              return SplashScreen();
                            }
                            if (state is ProfLoadInProgress) {
                              return SplashScreen();
                            }
                            if (state is ProfLoadSuccess) {
                              //isStudent
                              log.fine("prof");
                              Base.thisProf = state.prof;
                              return Base();
                            }
                            if (state is ProfLoadFailure) {}
                            return Container();
                          });
                    }
                    return Container();
                  },
                );
              }
              return Base();
            }
            return Container();
          },
        );
      }
      if (state is RolesLoadFailure) {
        return Text(
          'Something went wrong!',
          style: TextStyle(color: Colors.red),
        );
      }
      return Container();
    });
  }
}

class Base extends StatefulWidget {
  static int selectedIndex = 0;
  static List<RoleModel> allRoles;
  static List<ClubModel> allClubs;
  static List<EventModel> allEvents;
  static StudentModel thisUser;
  static ClubModel thisClub;
  static ProfModel thisProf;
  static String token;

  @override
  _Base createState() => _Base();
}

class _Base extends State<Base> {
  final log = Logger('BASE');

  PageController pageController =
  PageController(initialPage: Base.selectedIndex);

  List<Widget> _widgetOptions;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  EventRepository eventRepository = EventRepository(
    eventApiProvider: EventApiProvider(
      client: Client(),
    ),
  );
  EventsBloc eventsBloc;

  static List<Widget> _selectedAppbarTitleWidget(context) {
    ImageProvider<Object> image = AssetImage('assets/esieeplus/color_LetterLogo.webp');
    if(Provider.of<AppStateNotifier>(context, listen: false).isDarkMode) {
      image = AssetImage('assets/esieeplus/white_LetterLogo.webp');
    }
    return [
      Center(
        child: Image(
            image: image,
            height: 25,
            width: 100,
            fit: BoxFit.fill
        ),
      ),
      Text('Emploi du temps', style: TextStyle(fontSize: 25),),
      Text('Evenements', style: TextStyle(fontSize: 25),),
    ];
  }

  List<Widget> actionButton() {
    ColorDetect c = ColorDetect(user.photoUrl, context);
    if (Base.selectedIndex == 0) {
      return [
        FutureBuilder(
            future: c.getColor(),
            builder: (_, AsyncSnapshot<Color> data) {
              if (data.connectionState == ConnectionState.done) {
                Color color = data.data;
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile(color)),
                  ),
                  child: Container(
                    //padding: EdgeInsets.all(15),
                    color: Theme.of(context).backgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Hero(
                        tag: "photo",
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                          backgroundColor: Theme.of(context).backgroundColor,
                          radius: 20,
                        )
                    ),
                  ),
                );
              }
              return CircleAvatar(
                backgroundColor: Theme.of(context).backgroundColor,
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
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              duration: Duration(seconds: 3),
              content: Text(
                  "ESIEE+ ne peut être tenu responsable des erreurs eventuelles de l'agenda.",
                  textAlign: TextAlign.justify),
              backgroundColor: Colors.blueAccent,
            ));
          },
        ),
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
    final EventRepository eventRepository = EventRepository(
      eventApiProvider: EventApiProvider(
        client: Client(),
      ),
    );
    eventsBloc = EventsBloc(eventRepository: eventRepository);
    _widgetOptions = <Widget>[
      KeepAlivePage(
          child: BlocProvider<EventsBloc>(
              create: (BuildContext context) => eventsBloc, child: Home())),
      KeepAlivePage(child: Calendar()),
      KeepAlivePage(child: EventList(eventsBloc: eventsBloc)),
    ];
    if (Base.thisUser == null) _widgetOptions.removeAt(1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    pageController.animateToPage(
      index,
      curve: Curves.bounceIn,
      duration: Duration(milliseconds: 100),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      Base.selectedIndex = index;
    });
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    log.fine("base");

    if (Base.thisUser == null &&
        Base.thisClub == null &&
        Base.thisProf == null) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: LoginPage(),
      );
    } else {
      return _getApp();
    }
  }

  Widget _getApp() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.dehaze, size: 30),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            title: _selectedAppbarTitleWidget(context).elementAt(Base.selectedIndex),//Text(_selectedAppbarTitle.elementAt(Base.selectedIndex)),
            actions: actionButton()),
        body: PageView(
          controller: pageController,
          children: _widgetOptions,
          onPageChanged: _onPageChanged,
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
            child: Container (
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: <Widget>[
                  Expanded(
                    // ListView contains a group of widgets that scroll inside the drawer
                    child: ListView(
                      children: <Widget>[
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
                        SizedBox(height: 15,),
                        _adminMenu(),
                        _modoMenu(),
                        _trezMenu(),
                        _logMenu(),
                        _clubMenu(),
                        _studentMenu(),
                        _profMenu(),
                      ],
                    ),
                  ),
                  // This container holds the align
                  Container(
                      child: Align(
                        //alignment: FractionalOffset.bottomCenter,
                          child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                            Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? FontAwesomeIcons.lightbulb : FontAwesomeIcons.solidLightbulb,
                                            size: 25,
                                            color: Theme.of(context).primaryColor.withOpacity(0.8)
                                        ),
                                        onPressed: () => {
                                          Provider.of<AppStateNotifier>(context, listen: false).updateTheme(!Provider.of<AppStateNotifier>(context, listen: false).isDarkMode),
                                          MyTheme.SetStatusBarColor(context)
                                        },
                                        splashColor: null,
                                      ),
                                    ],
                                  ),
                                  /*ListTile(
                                  leading: Icon(Icons.settings),
                                  title: Text('Settings')),
                              ListTile(
                                  leading: Icon(Icons.help),
                                  title: Text('Help and Feedback'))*/
                                ],
                              )
                          )
                      )
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _MenuTitle() {
    return Divider(
      height: 1,
      thickness: 1.5,
      color: MyTheme.ColorTheme(context, colorLight: Colors.black12, colorDark: Colors.white10),
    );
  }

  Widget _requireConnectionTile(IconData icon, String title, Widget route) {
    return FutureBuilder(
        future: isInternetConnected(),
        builder: (BuildContext context, AsyncSnapshot<bool> connected) {
          return connected.hasData && connected.data
              ? ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            leading: Icon(icon,
                color: Theme.of(context).primaryColor.withOpacity(0.8)),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColor),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return route;
              }));
            },
          )
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
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.import_contacts,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Cours",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClassDocumentUpload();
            }));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.group,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Notification Classe",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClassNotification();
            }));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.chat,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Messenger",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
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

  Widget _clubMenu() {
    if (Base.thisClub != null) {
      return Column(children: [
        _MenuTitle(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.account_balance_wallet,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Mon Fairpay",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              final FairpayLogRepository fairpayLogRepository =
              FairpayLogRepository(
                fairpayLogApiProvider: FairpayLogApiProvider(
                  client: Client(),
                ),
              );
              return BlocProvider<FairpayLogsBloc>(
                  create: (BuildContext context) => FairpayLogsBloc(
                      fairpayLogRepository: fairpayLogRepository),
                  child: Fairpay());
            }));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.group_add,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Gestion des Membres",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              final StudentRepository studentsRepository = StudentRepository(
                studentApiProvider: StudentApiProvider(
                  client: Client(),
                ),
              );
              final ClubRepository clubRepository = ClubRepository(
                clubApiProvider: ClubApiProvider(
                  client: Client(),
                ),
              );
              StudentsBloc studentsBloc =
              StudentsBloc(studentRepository: studentsRepository);
              ClubsBloc clubsBloc = ClubsBloc(clubRepository: clubRepository);
              return BlocProvider(
                  create: (BuildContext context) => studentsBloc,
                  child: BlocProvider(
                      create: (BuildContext context) => clubsBloc,
                      child: ClubMemberManager(
                          studentsBloc: studentsBloc, clubsBloc: clubsBloc)));
            }));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.chat,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Messenger",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              final ProfRepository profRepository = ProfRepository(
                profApiProvider: ProfApiProvider(
                  client: Client(),
                ),
              );
              final StudentRepository studentRepository = StudentRepository(
                studentApiProvider: StudentApiProvider(
                  client: Client(),
                ),
              );
              ProfsBloc profsBloc = ProfsBloc(profRepository: profRepository);
              StudentsBloc studentsBloc =
              StudentsBloc(studentRepository: studentRepository);
              return BlocProvider(
                  create: (BuildContext context) => profsBloc,
                  child: BlocProvider<StudentsBloc>(
                      create: (BuildContext context) => studentsBloc,
                      child: MessengerHistory()));
            }));
          },
        ),
      ]);
    }
    return Column();
  }

  Widget _studentMenu() {
    if (Base.thisUser != null) {
      final FreeRoomsRepository freeRoomsRepository = FreeRoomsRepository(
        freeRoomsApiProvider: FreeRoomsApiProvider(
          client: Client(),
        ),
      );
      return Column(children: [
        _MenuTitle(),
        //_MenuElmt(Icons.credit_card, "Ma carte", EsieeCard()),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.group,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Clubs",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ClubList();
            }));
          },
        ),

        _requireConnectionTile(
            Icons.location_on,
            "Salles Libres",
            BlocProvider<FreeRoomsBloc>(
                create: (BuildContext context) =>
                    FreeRoomsBloc(freeRoomRepository: freeRoomsRepository),
                child: FreeRooms())),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.contacts,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Liste des Professeurs",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              final ProfRepository profRepository = ProfRepository(
                profApiProvider: ProfApiProvider(
                  client: Client(),
                ),
              );
              final UnitRepository unitRepository = UnitRepository(
                unitApiProvider: UnitApiProvider(
                  client: Client(),
                ),
              );
              ProfsBloc profsBloc = ProfsBloc(profRepository: profRepository);
              return BlocProvider<UnitsBloc>(
                  create: (BuildContext context) =>
                      UnitsBloc(unitRepository: unitRepository),
                  child: UnitsList(profsBloc: profsBloc));
            }));
          },
        ),
        //_MenuElmt(Icons.import_contacts, "Cours", ClassDocument()),
        //_MenuElmt(Icons.class_, "Annales", AnnalsList()),
        //_MenuElmt(Icons.chat, "Messenger", MessengerHistory()),
      ]);
    }
    return Column();
  }

  Widget _adminMenu() {
    if (Base.thisUser != null &&
        Base.thisUser.roles.contains(Base.allRoles
            .firstWhere((element) => element.role == Role.admin)) ||
        Base.thisClub != null &&
            Base.thisClub.roles.contains(Base.allRoles
                .firstWhere((element) => element.role == Role.admin))) {
      final StudentRepository studentRepository = StudentRepository(
        studentApiProvider: StudentApiProvider(
          client: Client(),
        ),
      );

      return Column(children: [
        _MenuTitle(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.beenhere,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Ajout Cotisants",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BlocProvider<StudentsBloc>(
                  create: (BuildContext context) =>
                      StudentsBloc(studentRepository: studentRepository),
                  child: ContributorManager());
            }));
          },
        ),
        _requireConnectionTile(
            Icons.group_add,
            "Droits Utilisateurs",
            BlocProvider<StudentsBloc>(
                create: (BuildContext context) =>
                    StudentsBloc(studentRepository: studentRepository),
                child: UserPermissions()))
      ]);
    }
    return Column();
  }

  Widget _modoMenu() {
    if (Base.thisUser != null &&
        Base.thisUser.roles.contains(Base.allRoles
            .firstWhere((element) => element.role == Role.mod)) ||
        Base.thisClub != null &&
            Base.thisClub.roles.contains(Base.allRoles
                .firstWhere((element) => element.role == Role.mod))) {
      final StudentRepository studentRepository = StudentRepository(
        studentApiProvider: StudentApiProvider(
          client: Client(),
        ),
      );
      return Column(children: [
        _MenuTitle(),
        _requireConnectionTile(
            Icons.date_range,
            "Gestion Evènements",
            EventManager(
              eventsBloc: eventsBloc,
            )),
        _requireConnectionTile(
            Icons.verified_user,
            "Cotisants",
            BlocProvider<StudentsBloc>(
                create: (BuildContext context) =>
                    StudentsBloc(studentRepository: studentRepository),
                child: ContributorVerificator())),
        _requireConnectionTile(Icons.person_add, "Ajout Professeur", AddProf())
      ]);
    }
    return Column();
  }

  Widget _trezMenu() {
    if (Base.thisUser != null &&
        Base.thisUser.roles.contains(Base.allRoles
            .firstWhere((element) => element.role == Role.trez)) ||
        Base.thisClub != null &&
            Base.thisClub.roles.contains(Base.allRoles
                .firstWhere((element) => element.role == Role.trez))) {
      return Column(children: [
        _MenuTitle(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.euro_symbol,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Gestion Trésorerie",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              final FairpayLogRepository fairpayLogRepository =
              FairpayLogRepository(
                fairpayLogApiProvider: FairpayLogApiProvider(
                  client: Client(),
                ),
              );
              return BlocProvider<FairpayLogsBloc>(
                  create: (BuildContext context) => FairpayLogsBloc(
                      fairpayLogRepository: fairpayLogRepository),
                  child: TreasuryManager());
            }));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.equalizer,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Gestion Fairpay",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              final FairpayLogRepository fairpayLogRepository =
              FairpayLogRepository(
                fairpayLogApiProvider: FairpayLogApiProvider(
                  client: Client(),
                ),
              );
              FairpayLogsBloc fairpayLogsBloc =
              FairpayLogsBloc(fairpayLogRepository: fairpayLogRepository);
              return FairPayManager(bloc: fairpayLogsBloc);
            }));
          },
        ),
      ]);
    }
    return Column();
  }

  Widget _logMenu() {
    if (Base.thisUser != null &&
        Base.thisUser.roles.contains(Base.allRoles
            .firstWhere((element) => element.role == Role.log)) ||
        Base.thisClub != null &&
            Base.thisClub.roles.contains(Base.allRoles
                .firstWhere((element) => element.role == Role.log))) {
      return Column(children: [
        _MenuTitle(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          leading: Icon(Icons.local_grocery_store,
              color: Theme.of(context).primaryColor.withOpacity(0.8)),
          title: Text(
            "Réserve",
            style:
            TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              final StockRepository stockRepository = StockRepository(
                stockApiProvider: StockApiProvider(
                  client: Client(),
                ),
              );
              StockBloc bloc = StockBloc(stockRepository: stockRepository);
              return BlocProvider(
                  create: (BuildContext context) => bloc,
                  child: Stocks(bloc: bloc));
            }));
          },
        ),
      ]);
    }
    return Column();
  }

  Widget getBottomNavigationBar() {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.home,),
        //activeIcon: Icon(FontAwesomeIcons.home, color: Theme.of(context).primaryColor,),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.clock,),
        //activeIcon: Icon(FontAwesomeIcons.clock, color: Theme.of(context).primaryColor,),
        title: Text('EDT'),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.calendarAlt,),
        //activeIcon: Icon(FontAwesomeIcons.calendarAlt, color: Theme.of(context).primaryColor,),
        title: Text('Event',),
      ),
    ];
    if (Base.thisUser == null) items.removeAt(1);
    return BottomNavigationBar(
      items: items,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: Base.selectedIndex,
      //selectedItemColor: Theme.of(context).primaryColor,
      onTap: _onItemTapped,
    );
  }
}
