import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../blocs/events_bloc.dart';
import 'package:intl/intl.dart';
import 'event_create.dart';

class EventList extends StatelessWidget {
  final log = Logger('eventList');

  @override
  Widget build(BuildContext context){
    bloc.fetchAllEvents();
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.allEvents,
        builder: (context, AsyncSnapshot<List<EventModel>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreationPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      )
    );
  }

  Widget buildList(AsyncSnapshot<List<EventModel>> snapshot) {

    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data[index].image),
            ),
            title: Text(snapshot.data[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventInfoPage(event : snapshot.data[index])),
              );
            },
          );
        });
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }

  String getMonth(DateTime date){
    return new DateFormat('MMMM').format(date);
  }

}

//When user click on an event
class EventInfoPage extends StatelessWidget{
  /// TODO : Affichage des infos de l'event
  final EventModel event;
  EventInfoPage({this.event});

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(event.image)
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        )
      )
    );
  }
}

//When user (Club) click on add button
class EventCreationPage extends StatelessWidget{

  @override Widget build(BuildContext context){
    return new Scaffold(
      body : Text("text")
    );
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

