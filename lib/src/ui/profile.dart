import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/resources/translations.dart';
import 'package:bde_esiee_mobile/src/ui/card_esiee_plus.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {

  final Color color;
  Profile(this.color);

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
          child: Container(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      stops: [0.33, 0.66],
                      colors: [widget.color, widget.color.withOpacity(0.85) ] )),
              child: Stack(
                  children: [
                    backButton(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 60),
                        Hero(
                            tag: "photo",
                            child:Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.0),
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.photoUrl),
                                radius: 50,
                              ),
                            )),
                        SizedBox(height: 20,),
                        Column(
                          children: [
                            Text(user.displayName.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 30)),
                            SizedBox(height: 5),
                            Text(user.email, style: TextStyle(color: Colors.white70, fontSize: 17)),
                            SizedBox(height: 10),
                            Base.thisUser != null ? Text(parsePromo(Base.thisUser) + "${Base.thisUser.roles.isNotEmpty ? ', ' : '' }" + parseRole(Base.thisUser.roles), style: TextStyle(color: Colors.white, fontSize: 17)) : Base.thisProf == null ? Text(parseRole(Base.thisClub.roles), style: TextStyle(color: Colors.white, fontSize: 17)) : Container(),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Column(
                                  children: [
                                    Divider(color: Colors.white54, thickness: 2, indent: 20, endIndent: 20,),
                                    SizedBox(height: 15),
                                    Base.thisUser != null && Base.thisUser.isContributor ?
                                    sectionCotisant() : Base.thisClub != null ? sectionClub() : Container(),
                                  ],
                                )
                            )
                          ],
                        ),
                        Base.thisUser != null ? _cardEsieePlus() : Container(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 70),
                          child: RaisedButton(
                              color: Color.fromRGBO(255,153,51,1),
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Container(
                                  constraints: BoxConstraints(maxWidth: 190.0, minHeight: 50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.power_settings_new, color: Colors.white,),
                                      SizedBox(width: 10,),
                                      Text(Translations.of(context).text("deco").toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                                    ],
                                  )
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                signOutGoogle();
                                Base.selectedIndex = 0;
                              }
                          ),
                        ),
                      ],
                    )])
          )),
    );
  }

  backButton() => Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 10, left: 10),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        color: Colors.transparent,
        onPressed: () { if(Navigator.canPop(context)) Navigator.pop(context); },
      )
  );

  parsePromo(StudentModel student) {
    return student.promo.split("_")[1];
  }

  parseRole(List roles) {
    return roles.length > 0 ?  roles.toString().replaceFirst("[", "").replaceFirst("]", "") : "";
  }

  sectionCotisant() => Column(
    children: [
      Text("TU ES COTISANT", style: TextStyle(color: Colors.white, fontSize: 25)),
      SizedBox(height: 10),
      Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: FlareActor(
              "assets/flr/medal.flr",
              alignment: Alignment.center,
              fit: BoxFit.fill,
              animation: "default",
            ),
          )

      )
    ],
  );

  _cardEsieePlus() {
    return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CardEsieePlus(asPage: true,)),
        ),
        child: CardEsieePlus(asPage: false,)
    );
  }

  sectionClub() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      solde(),
      classement()
    ],
  );

  solde() => Column(
    children: [
      Text("${Base.thisClub.solde.toString()}  €", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700),),
      Text("Solde Actuel", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.blue[100]),),
    ],
  );

  classement() => Column(
    children: [
      Text("${Base.thisClub.students.length.toString()}", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700),),
      Text("Membres", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.blue[100]),),
    ],
  );

}
