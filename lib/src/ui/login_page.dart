import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {


  LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Image(image: AssetImage('assets/esieeplus/LogoFond.webp'), width: 150),
                      elevation: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 70),
                      child: _isLoading ? CircularProgressIndicator() : _signInButton(context),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Row(
                  children: <Widget>[
                    Text("Développée par ", style: TextStyle(fontSize: 15),),
                    Text(
                      "BDE Django",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green[800],
                      ),
                    ),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/esieeplus/logoDjango.webp'),
                      backgroundColor: Theme.of(context).backgroundColor,
                      radius: 15,
                    ),
                  ]
              ),
            )
          ]
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return RaisedButton(
        color: Theme.of(context).primaryColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Container(
            constraints: BoxConstraints(maxWidth: 190.0, minHeight: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.google, color: MyTheme.ColorTheme(context, colorDark: MyTheme.SelectedColor, colorLight: Colors.white),),
                SizedBox(width: 10,),
                Text("Se connecter".toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyTheme.ColorTheme(context, colorDark: MyTheme.SelectedColor, colorLight: Colors.white),)),
              ],
            )
        ),
        onPressed: () async {
          setState(() => _isLoading = true);
          user = await signInWithGoogle();
          setState(() => _isLoading = false);
          if (user != null) {
            if(!user.email.endsWith("esiee.fr")) {
              signOutGoogle();
            }
          } else {
            signOutGoogle();
          }
        }
    );
  }
}
