import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/Hyperlink.dart';

// ignore: must_be_immutable
class CustomItemWithIcon extends StatefulWidget {
  final IconData icon;
  final String text;
  String hyperlink;

  CustomItemWithIcon(this.icon, this.text, {this.hyperlink}){
    if(this.hyperlink != null) this.hyperlink = this.hyperlink;
    else this.hyperlink = null;
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
              Icon(widget.icon, size: 20.0, color: MyTheme.PrimaryColorLight),
              _type(),
            ]),
      );
    }
    return Container();
  }

  _type() {
    if(widget.hyperlink != null)
      return Hyperlink(widget.hyperlink, widget.text);
    else return Text(widget.text, style: TextStyle(fontSize: 18,),textAlign: TextAlign.justify,);
  }

}