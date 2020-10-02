import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/HomeComponents.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../App.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  final eventBloc = EventsBloc();
  final rate = 10;

  @override
  void initState() {
    eventBloc.fetchAllEvents();
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);*/
    super.initState();
  }

  @override
  void dispose() {
    eventBloc.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _header(context),
                Container(
                  height: MediaQuery.of(context).size.height-460,
                  child: HomeComponents(),
                ),
                /*Container(
                  height : MediaQuery.of(context).size.height-153-270-62,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height : MediaQuery.of(context).size.height-153-270-62-150,
                        width: MediaQuery.of(context).size.width-75,
                        child: FlareActor(
                          "assets/flr/intro.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                          animation: "coding",
                        ),
                      ),
                      Text("Page d'accueil en cours de création...", style: TextStyle(fontSize: 23, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),*/
                _Links()
              ],
            )
        )
    );
  }

  _Links() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      //height: 62,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _homeStudentUsefulLinks("Webaurion", "https://webaurion.esiee.fr/", "https://media-exp1.licdn.com/dms/image/C4D0BAQFbOzrZBcQXgA/company-logo_200_200/0?e=2159024400&v=beta&t=TzGOdwYwDfAOQ51SmYuSV6XaC8-uHv39pj-xLw3H2y0"),
          _homeStudentUsefulLinks("Blackboard", "https://esiee.blackboard.com/", "https://www.osa.fu-berlin.de/studieneinstieg/en/_media/grafiken/BlackboardMobileLearnAppIcon.png"),
          _homeStudentUsefulLinks("ICampus", "https://icampus.esiee.fr/", "https://enovationsolutions.fr/wp-content/uploads/2018/02/moodle-logo-300x225.png"),
          _homeStudentUsefulLinks("Intra", "https://intra.esiee.fr/", "https://www.esiee.fr/sites/all/themes/custom/esiee_theme/logo.png"),
        ],
      ),
    );
  }

  _header(BuildContext context) {
    return Container(
      //height: 270.0-30.0,
      //color: Colors.blueGrey,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150.0,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image : AssetImage("assets/esieeplus/defaultbanner.png")
                      )
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Text(user.displayName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor,),),
                    Base.thisUser != null && Base.thisUser.isContributor ?
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      width: 20.0,
                      height: 20.0,
                      child: FlareActor(
                        "assets/flr/medal.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        animation: "default",
                      ),
                    ) : Container(),
                  ],
                ),
              ),
              /*Container(
                //color: Colors.blue,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 5,
                  children: _ListStudentClub(),
                ),
              ),*/
            ],
          ),
          Positioned(
            top: 100,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 100.0,
                height: 100.0,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image:
                    new NetworkImage(user.photoUrl),
                  ),
                  //border: Border.all(color: Background, width: 2),
                )
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _ListStudentClub() {
    List<Widget> list = List<Widget>();
    list.add(
      Container(
          width: 30.0,
          height: 30.0,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image:
              new NetworkImage("https://firebasestorage.googleapis.com/v0/b/bde-esiee-mobile.appspot.com/o/clubs%2FBDE.png?alt=media&token=85e40648-55ce-4096-8f5b-fc0ce5955167"),
            ),
          )
      ),
    );
    list.add(
      Container(
          width: 30.0,
          height: 30.0,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image:
              new NetworkImage("https://firebasestorage.googleapis.com/v0/b/bde-esiee-mobile.appspot.com/o/clubs%2FFZY.png?alt=media&token=cdb5de46-6b14-4d1b-b387-ac31541737d4"),
            ),
          )
      ),
    );
    return list;
  }

  _homeStudentUsefulLinks(String nom, String site, String image,) {
    return InkWell(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: 40.0,
                height: 40.0,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.scaleDown,
                    image:
                    new NetworkImage(image),
                  ),
                )
            ),
            Text(nom, style: TextStyle(fontSize: 10),),
          ],
        ),
      ),
      customBorder: CircleBorder(),
      onTap: () async {
        await launch(site);
      },
    );
  }

  List<Widget> _ListProfUnits() {
    List<Widget> list = List<Widget>();
    Base.thisProf.units.forEach((element) {list.add(
        Chip(
          label: Text(element.unitCode, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color : Colors.white)),
          //backgroundColor: PrimaryColor,
        )
    );});
    return list;
  }

}
