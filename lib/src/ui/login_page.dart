import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/ui/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    if(user != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return App();
      }));
    }
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("BDE ESIEE PARIS", style: TextStyle(fontSize: 30, color: Colors.lightGreen, fontWeight: FontWeight.bold),),
              SizedBox(height: 50),
              Image(image: AssetImage('assets/logoDjango.png'), width: 300),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return RaisedButton(
        child: Text("Se connecter avec Google"),
        onPressed: () {
          signInWithGoogle().whenComplete(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return App();
            }));
          });
        });
  }
}
