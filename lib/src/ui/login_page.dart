import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {

  bool withoutButton;

  LoginPage({this.withoutButton}) {
    this.withoutButton!=null ? this.withoutButton=true : this.withoutButton=false;
  }

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
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              /*decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [TertiaryColor, PrimaryColor],
                    begin: Alignment.topRight,
                    end: Alignment.center,
                  ),
                  borderRadius: BorderRadius.circular(30.0)
              ),*/
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/Logo.png'), width: 200),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              child: widget.withoutButton ? Container() : _isLoading ? CircularProgressIndicator() : _signInButton(context),
            ),
            Positioned(
              bottom: 10,
              child: Row(
                  children: <Widget>[
                    Text("Développée par ", style: TextStyle(fontSize: 15),),
                    Text(
                      "BDE Django",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green[800], /*letterSpacing:1,
                          shadows: [
                        Shadow( // bottomLeft
                            offset: Offset(-0.3, -0.3),
                            color: Colors.white
                        ),
                        Shadow( // bottomRight
                            offset: Offset(0.3, -0.3),
                            color: Colors.white
                        ),
                        Shadow( // topRight
                            offset: Offset(0.3, 0.3),
                            color: Colors.white
                        ),
                        Shadow( // topLeft
                            offset: Offset(-0.3, 0.3),
                            color: Colors.white
                        ),
                      ]*/),
                    ),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/logoDjango.png'),
                      backgroundColor: Colors.white,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            color: PrimaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(30.0)
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text("Se connecter avec Google".toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
          ),
        ),
        onPressed: () async {
          setState(() => _isLoading = true);
          user = await signInWithGoogle();
          setState(() => _isLoading = false);
//          if (user != null) {
//            if(!user.email.endsWith("esiee.fr")) {
//              signOutGoogle();
//              Scaffold.of(context).showSnackBar(new SnackBar(
//                duration: Duration(seconds: 3),
//                content: Text("Utilisateur non autorisé"),
//                backgroundColor: Colors.red,
//              ));
//            }
//          }
        });
  }
}
