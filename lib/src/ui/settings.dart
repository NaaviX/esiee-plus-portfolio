import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}
class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Paramètres"),
        ),
        body:Text("TO DO"));
  }


}