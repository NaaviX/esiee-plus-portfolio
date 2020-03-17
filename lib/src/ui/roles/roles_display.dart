import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:flutter/material.dart';

class RolesDisplay extends StatefulWidget {
  final List<RoleModel> roles;

  RolesDisplay(this.roles);

  @override
  State<StatefulWidget> createState() {
    return RolesDisplayState();
  }

}
class RolesDisplayState extends State<RolesDisplay> {
  @override
  Widget build(BuildContext context) {
    List<MaterialColor> colors = [];
    for(RoleModel role in widget.roles) {
      if(role.role == 'mod')
        colors.add(Colors.blue);
      if(role.role == 'log')
        colors.add(Colors.green);
      if(role.role == 'admin')
        colors.add(Colors.red);
      if(role.role == 'trez')
        colors.add(Colors.yellow);
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List<Widget>.generate(widget.roles.length, (int index) {
        return Chip(
          label: Text(widget.roles.elementAt(index).role.toUpperCase()),
          backgroundColor: colors[index].shade50,
        );
      }),
    );
  }

}