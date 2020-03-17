import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  @required String label, hint;

  @required IconData icon;
  @required TextEditingController controller;
  FocusNode focusNode;

  String type ;
  TextStyle textstyle;
  int maxlines;
  TextInputType keyboard;
  bool requiredField;
  int maxLength;

  InputDecoration decoration;

  _hinttextStyle() => TextStyle(color: Colors.black12, fontSize: 15.0,);
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
  _inputDescDecoration(label, hint) => InputDecoration(
    labelText: label,
    fillColor: Colors.white,
    border: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(18.0),
        borderSide: new BorderSide()),
    hintText:hint,
    hintStyle: _hinttextStyle(),
  );


  CustomTextFormField(this.label, this.hint, this.icon, this.controller, {this.type, this.textstyle, this.maxlines, this.keyboard, this.requiredField, this.maxLength, this.focusNode})
  {
    if(this.textstyle != null) this.textstyle = this.textstyle;
    else this.textstyle = TextStyle(color: Colors.black, fontSize: 15.0,);

    if(this.maxlines != null) this.maxlines = this.maxlines;
    else this.maxlines = 1;

    if(this.keyboard != null) this.keyboard = this.keyboard;
    else this.keyboard = TextInputType.text;

    if(this.requiredField != null) this.requiredField = this.requiredField;
    else this.requiredField = false;

    if(this.maxLength != null) this.maxLength = this.maxLength;
    else this.maxLength = 1000000000;

    this.decoration = _inputDecoration(label, hint, icon);

    if(this.type == "titre") {
      this.textstyle = TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold);
      this.maxlines = 1;
      this.keyboard = TextInputType.text;

      this.decoration = _inputDecoration(label, hint, icon);
    }
    else if(this.type == "desc")
    {
      this.textstyle = TextStyle(color: Colors.black, fontSize: 15.0,);
      this.maxlines = 5;
      this.keyboard = TextInputType.multiline;

      this.decoration = _inputDescDecoration(label, hint);
    }
  }

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration,
      validator: (val) => _ifNull(val),
      style: widget.textstyle,
      maxLines: widget.maxlines,
      keyboardType: widget.keyboard,
      controller: widget.controller,
      focusNode: widget.focusNode,
    );
  }

  _ifNull(val) {
    if (val.isEmpty && widget.requiredField == true) {
      return '*Champs requis';
    }
    else if (val.toString().length > widget.maxLength) {
      return 'La longueur maximun du champs est de ' + widget.maxLength.toString() + ' charactère(s)';
    }
    return null;
  }
}