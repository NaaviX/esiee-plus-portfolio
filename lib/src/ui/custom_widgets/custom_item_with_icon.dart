import 'package:flutter/material.dart';
import '../custom_widgets/Hyperlink';

class CustomItemWithIcon extends StatefulWidget {
  final IconData icon;
  final String text;
  bool hyperlink;

  CustomItemWithIcon(this.icon, this.text, {this.hyperlink}){
    if(this.hyperlink != null) this.hyperlink = this.hyperlink;
    else this.hyperlink = false;
  }

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
              _type(),
            ]),
      );
    }
    return Container();
  }

  _type() {
    if(!widget.hyperlink)
      return Text(widget.text, style: TextStyle(fontSize: 18,),textAlign: TextAlign.justify,);
    else return Hyperlink(widget.text, widget.text);
  }

}