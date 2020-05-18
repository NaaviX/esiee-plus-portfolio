import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "ESIEE Plus",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold),
                    ),

                    Image(image: AssetImage('assets/logoDjango.png'), width: 300),
                    SizedBox(height: 50),
                    _isLoading ? CircularProgressIndicator() : _signInButton(context),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green[800]),
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

        child: Text("Se connecter avec Google"),
        onPressed: () async {
          setState(() => _isLoading = true);
          user = await signInWithGoogle();
          setState(() => _isLoading = false);
          if (user != null) {
            if(!user.email.endsWith("esiee.fr")) {
              signOutGoogle();
              Scaffold.of(context).showSnackBar(new SnackBar(
                duration: Duration(seconds: 3),
                content: Text("Utilisateur non autorisé"),
                backgroundColor: Colors.red,
              ));
            }
          }
        });
  }
}
