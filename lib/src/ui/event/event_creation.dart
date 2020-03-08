import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';

class EventCreation extends StatelessWidget {

  @override Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: Text("Nouvel Evenement")
        ),
        body: createEventForm()
    );
  }
}

// Create a Form widget.
class createEventForm extends StatefulWidget {

  @override
  createEventFormState createState() {
    return createEventFormState();
  }

}

class createEventFormState extends State<createEventForm> {
  final _formKey = GlobalKey<FormState>();

  var startdate = DateTime.now();
  var enddate = DateTime.now();
  var pubdate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  newTextInput(
                      'Intitulé de l\'évenement', 'Please enter some text',
                      Icon(Icons.calendar_today)),
                  newLongTextInput('Description', 'Please enter some text'),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                          child: new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            elevation: 4.0,
                            onPressed: callDatePickerStart,
                            child: datetimeButton("start"),
                            color: Colors.white,
                          )
                      )),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                          child: new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            elevation: 4.0,
                            onPressed: callDatePickerEnd,
                            child: datetimeButton("end"),
                            color: Colors.white,
                          )
                      )),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                          child: new RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            elevation: 4.0,
                            onPressed: callDatePickerPub,
                            child: datetimeButton("publication"),
                            color: Colors.white,
                          )
                      )
                  ),
                  newTextInput(
                      'Lieu', 'Please enter some text', Icon(Icons.person)),
                  newNumberInput('Prix', 'Please enter some text',
                      Icon(Icons.attach_money)),
                  SizedBox(height: 20.0),
                  newTextInput('Lien Vente', 'Please enter some text',
                      Icon(Icons.payment)),
                  SizedBox(height: 20.0),
                  newTextInput('Lien Event Facebook', 'Please enter some text',
                      Icon(Icons.link)),
                  SizedBox(height: 20.0),
                  newTextInput(
                      'id club', 'Please enter some text', Icon(Icons.person)),
                  SizedBox(height: 20.0),
                  newTextInput('Background url', 'Please enter some text',
                      Icon(Icons.image)),
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          color: Colors.teal,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'CREER',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20),
                              )),
                          splashColor: Colors.white,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Processing Data')));
                            }
                          },
                        ),
                      ))
                ],
              ))),
    );
  }

  Widget newTextInput(String hintText, String ifEmpty, Icon icon) {
    return new Padding(
        padding: EdgeInsets.all(4.0),
        child: TextFormField(
            decoration: new InputDecoration(
              icon: icon,
              labelText: hintText,
              fillColor: Colors.white70,
              //fillColor: Colors.green
            ),
            validator: (value) {
              if (value.isEmpty) {
                return ifEmpty;
              }
              return null;
            }
        ));
  }

  Widget newLongTextInput(String hintText, String ifEmpty) {
    return new TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
            hintText: hintText
        ),
        validator: (value) {
          if (value.isEmpty) {
            return ifEmpty;
          }
          return null;
        }
    );
  }

  Widget newNumberInput(String hintText, String ifEmpty, Icon icon) {
    return new TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            icon: icon,
            hintText: hintText
        ),
        validator: (value) {
          if (value.isEmpty) {
            return ifEmpty;
          }
          return null;
        }
    );
  }

  void callDatePickerStart() async {
    var order = await getDate();
    setState(() {
      if(order.isAfter(DateTime.now()))
        startdate = order;
    });
  }

  void callDatePickerEnd() async {
    var order = await getDate();
    setState(() {
      if(order.isAfter(startdate))
        enddate = order;
    });
  }

  void callDatePickerPub() async {
    var order = await getDate();
    setState(() {
      if(order.isAfter(DateTime.now()) && order.isBefore(enddate))
        pubdate = order;
    });
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  datetimeButton(String type) {
    String date;
    var color;
    var icon = Icons.access_time;

    if (type == 'start') {
      color = Colors.green;
      date = "  " + DateFormat("EEE dd MMM yyyy","fr_FR").format(startdate);
    }
    else if (type == 'end') {
      color = Colors.red;
      date =  "  " + DateFormat("EEE dd MMM yyyy","fr_FR").format(enddate);
    }
    else if (type == 'publication') {
      color = Colors.orange;
      date =  "  " + DateFormat("EEE dd MMM yyyy","fr_FR").format(pubdate);
      icon = Icons.timer;
    }

    return Container(
      alignment: Alignment.center,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 18.0,
                      color: color,
                    ),
                    Text(
                      date,
                      textScaleFactor: 2.0,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 8.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}