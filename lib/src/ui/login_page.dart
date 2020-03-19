import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  void initState() {
    if (user != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return App();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Builder(
        builder: (context) => Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "BDE ESIEE PARIS",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Image(image: AssetImage('assets/logoDjango.png'), width: 300),
              SizedBox(height: 50),
              _isLoading ? CircularProgressIndicator() : _signInButton(context),
            ],
          ),
        ),
      ),
    ));
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
              user = null;
              Scaffold.of(context).showSnackBar(new SnackBar(
                duration: Duration(seconds: 3),
                content: Text("Utilisateur non autorisé"),
                backgroundColor: Colors.red,
              ));
            } else {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return new App();
              }));
            }
          }
        });
  }
}
