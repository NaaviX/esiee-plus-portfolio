import 'dart:html';

import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../blocs/events_bloc.dart';
import 'package:intl/intl.dart';

class EventCreate extends StatelessWidget{

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Création"),
        ),
        body: Text("text")
    );
  }
}

//When user (Club) click on add button
class EventCreationPage extends StatelessWidget{

  final EventModel event = new EventModel();

  @override Widget build(BuildContext context){
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

