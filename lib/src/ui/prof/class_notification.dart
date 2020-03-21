import 'package:flutter/material.dart';

class ClassNotification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClassNotificationState();
  }
}
class ClassNotificationState extends State<ClassNotification> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Notification classe"),
    ),
    body:Text("TO DO"));
  }


}