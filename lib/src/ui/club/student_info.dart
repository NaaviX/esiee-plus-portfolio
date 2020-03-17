import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/custom_item_with_icon.dart';
import 'package:bde_esiee_mobile/src/ui/roles/roles_display.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class StudentDetail extends StatefulWidget {
  final StudentModel student;

  const StudentDetail(this.student);

  @override
  State<StatefulWidget> createState() {
    return StudentDetailState();
  }
}

class StudentDetailState extends State<StudentDetail> {
  final log = Logger('studentdetail');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.student.firstname + " " + widget.student.lastname),
      content: SingleChildScrollView(
          child: ListBody(
        children: <Widget>[
          Divider(
            color: Colors.black,
          ),
          CustomItemWithIcon(
              Icons.contacts, widget.student.idStudent.toString()),
          CustomItemWithIcon(Icons.email, widget.student.mailEsiee),
          CustomItemWithIcon(Icons.phone, widget.student.phone),
          CustomItemWithIcon(Icons.class_, widget.student.promo),
          RolesDisplay(widget.student.roles),
        ],
      )),
      actions: <Widget>[
        FlatButton(
          child: Text('Retour'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
