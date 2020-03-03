import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/resources/translations.dart';
import 'package:bde_esiee_mobile/src/ui/home.dart';
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
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                Translations.of(context).text("bde"),
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Image(image: AssetImage('assets/logoDjango.png'), width: 300),
              SizedBox(height: 50),
              _isLoading ? CircularProgressIndicator() : _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return RaisedButton(
        child: Text("Se connecter avec Google"),
        onPressed: () async {
          setState(() => _isLoading = true);
          FirebaseUser user = await signInWithGoogle();
          setState(() => _isLoading = false);
          if (user != null) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return new App();
            }));
          }
        });
  }
}
