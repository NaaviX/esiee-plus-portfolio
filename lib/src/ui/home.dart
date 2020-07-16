import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/custom_item_with_icon.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../App.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            _header(context),
            SizedBox(height: 20,),
            Container(
              height: MediaQuery.of(context).size.height - 490,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Divider(thickness: 3, height: 3,),
                    Container(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Salut"),
                            SizedBox(height: 5,),
                            Text("Bienvenu sur ESIEE+ merci de faire vivre ce projet c'est vraiment cool de ta part <3")
                          ],
                        ),
                      ),
                    ),
                    Divider(thickness: 10, height: 10,),
                    Container(
                      height: 165,
                      child: event(),
                    ),
                    //Divider(thickness: 3, height: 3,),
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
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
            ),
          ],
        )

    );
  }

  _header(BuildContext context) {
    return Container(
      height: 270,
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
                          fit: BoxFit.cover,
                          image : NetworkImage("http://www.perraultarchitecture.com/data/projet/fiche/1537/large_esiee_axe_md_00d_web_6bcc9.jpg")
                      )
                  )
              ),
              Container(
                //color: Colors.blueGrey,
                //height: 50,
                //margin: EdgeInsets.only(left: 120),
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Text(user.displayName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: PrimaryColor,),),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      width: 20.0,
                      height: 20.0,
                      child: FlareActor(
                        "assets/medal.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        animation: "default",
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.blue,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 5,
                  children: _ListStudentClub(),
                ),
              ),
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
                  border: Border.all(color: Background, width: 2),
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
                    fit: BoxFit.fill,
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
          backgroundColor: PrimaryColor,
        )
    );});
    return list;
  }

  event() {
    return Column(
        children: <Widget>[
          Stack(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100.0,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image : NetworkImage("https://bde.esiee.fr/uploads/media/news/0001/02/0733e9810ddb237699c6f8e548aa4b33fbffadb8.png")
                        )
                    )
                ),
              ]
          ),
          _Eventheader(),
        ]
    );
  }

  _Eventheader() {
    return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Jan.", style: TextStyle(fontSize: 10, color: Colors.red,)),
                Text("30", style: TextStyle(fontSize: 30,)),
              ],
            ),
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : <Widget>[
                      AutoSizeText(
                        "revision java".toUpperCase(),
                        style: TextStyle(color: Colors.black, fontSize: 20.0,),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                      Row(children: <Widget>[
                        Text("Organisé par "),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                              "Nix",
                              style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                        ),
                        SizedBox(width: 5,),
                        CircleAvatar(
                          backgroundImage: NetworkImage("widget.club.urlPhoto"),
                          backgroundColor: Colors.white,
                          radius: 10,
                        ),
                      ]
                      ),
                    ]
                )
            ),
          ),
          /*Container(
              padding: EdgeInsets.only(right: 20, top: 10),
              child: GestureDetector(
                  child: Icon(Icons.event_available, size: 40, color: (_isFav ? PrimaryColor : Colors.blueGrey.withOpacity(0.5))),
                  onTap: () {
                    setState(() {
                      _isFav = !_isFav;
                    });
                  }
              )
          )*/
        ]
    );
  }
}
