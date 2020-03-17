import 'package:flutter/material.dart';

class CustomItemWithIcon extends StatefulWidget {
  final IconData icon;
  final String text;

  CustomItemWithIcon(this.icon, this.text);

  @override
  State<StatefulWidget> createState() {
    return CustomItemWithIconState();
  }

}
class CustomItemWithIconState extends State<CustomItemWithIcon> {
  @override
  Widget build(BuildContext context) {
    if(widget.text != null && widget.text != "" && widget.icon != null) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 8),
        child: Wrap(
            spacing: 10,
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: <Widget>[
              Icon(widget.icon, size: 20.0, color: Colors.blue),
              Text(widget.text, style: TextStyle(fontSize: 18,),
                textAlign: TextAlign.justify,),
            ]),
      );
    }
    return Container();
  }

}