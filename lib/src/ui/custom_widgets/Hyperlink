import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Hyperlink extends StatelessWidget {
  final String _url;
  final String _text;

  Hyperlink(this._url, this._text);

  _launchURL() async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      Fluttertoast.showToast(
          msg: "Ce lien ne fonctionne pas",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos:1,
          backgroundColor: Colors.red.withOpacity(0.75),
          textColor: Colors.white,
          fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        _text,
        style: TextStyle(decoration: TextDecoration.underline, fontSize: 18,),
      ),
      onTap: _launchURL,
    );
  }
}