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
    List<Roles> listRoles = [];
    for(RoleModel role in widget.roles) {
      if(role.role == Role.admin) listRoles.add(Roles(1, "Admin", Colors.red.shade50));
      else if(role.role == Role.mod) listRoles.add(Roles(2, "Mod", Colors.blue.shade50));
      else if(role.role == Role.trez) listRoles.add(Roles(3, "Trez", Colors.yellow.shade50));
      else if(role.role == Role.log) listRoles.add(Roles(4, "Log", Colors.green.shade50));

      listRoles.sort((a,b) => a.id.compareTo(b.id));
    }

    return Wrap(
      spacing: 6.0,
      //runSpacing: 6.0,
      children: List<Widget>.generate(widget.roles.length, (int index) {
        return Chip(
          label: Text(listRoles[index].role),//widget.roles.elementAt(index).toString().toUpperCase()),
          backgroundColor: listRoles[index].color,
        );
      }),
    );
  }

}

class Roles {
  int id;
  String role;
  Color color;

  Roles(this.id, this.role, this.color);
}