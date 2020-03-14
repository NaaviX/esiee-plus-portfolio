import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  String label, hint;

  IconData icon;
  TextEditingController controller;
  CustomTextFormField(this.label, this.hint, this.icon, this.controller);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: _inputDecoration(
          widget.label, widget.hint,
          widget.icon),
      validator: (val) => _ifNull(val),
      style: TextStyle(
          color: Colors.black, fontSize: 18.0,),
      maxLines: 1,
      keyboardType: TextInputType.text,
      controller: widget.controller,
    );
  }

  _ifNull(val) {
    if (val.isEmpty) {
      return '*Champs requis';
    }
    return null;
  }

  _inputDecoration(label, hint, icon) => InputDecoration(
    labelText: label,
    fillColor: Colors.white,
    border: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(10.0),
        borderSide: new BorderSide()),
    prefixIcon: Padding(
      padding: EdgeInsets.all(0.0),
      child: Icon(icon, color: Colors.black54,),
    ),
    hintText:hint,
    hintStyle: _hinttextStyle(),
  );

  _hinttextStyle() => TextStyle(color: Colors.black12, fontSize: 15.0,);
}