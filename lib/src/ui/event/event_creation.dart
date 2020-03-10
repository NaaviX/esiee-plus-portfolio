import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class EventCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventCreationState();
  }
}

class EventCreationState extends State<EventCreation> {


  final log = Logger('eventCreation');

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

  final bloc = EventsBloc();
  final titre = TextEditingController();
  final place = TextEditingController();
  final description = TextEditingController();
  final link = TextEditingController();
  final fblink = TextEditingController();
  final price = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    titre.dispose();
    super.dispose();
  }

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
        child: Padding(
            padding: EdgeInsets.only(left:20, top:0, right:20, bottom:0),
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  _titreInputFiled(),
                  SizedBox(height: 15.0),
                  _descriptionInputFiled(),
                  SizedBox(
                    height: 10.0,
                  ),
                  //newLongTextInput('Description', 'Please enter some text'),
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
                  SizedBox(height: 10.0),
                  _placeInputFiled(),
                  SizedBox(height: 10.0),
                  _prixInputFiled(),
                  SizedBox(height: 10.0),
                  _venteInputFiled(),
                  SizedBox(height: 10.0),
                  _fbInputFiled(),
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                          ),
                          color: Colors.blue,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'CREER',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              )),
                          splashColor: Colors.white,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              bloc.addSaveEvent(
                                  new EventModel(
                                      idEvent: 0,
                                      name: titre.text,
                                      startDate: startdate,
                                      endDate: enddate,
                                      place: place.text,
                                      backgroundUrl: "",
                                      description: description.text,
                                      publicationDate: pubdate,
                                      link: link.text,
                                      facebookLink: fblink.text,
                                      idClubRef: 100,
                                      enable:true,
                                      price: int.parse(price.text)
                                  )
                              );

                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(backgroundColor: Colors.blue, content: Text('Evénement créé', style: TextStyle(color: Colors.white, fontSize: 17.0,))));
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ))
                ],
              )))),
    );
  }

  _titreInputFiled() => TextFormField(
    decoration: _inputDecoration("Nom de l'événement", "Intitulé de l\'évenement", Icons.calendar_today),
    validator: (val) => _ifNull(val),
    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
    maxLines: 1,
    keyboardType: TextInputType.text,
    controller: titre,
  );

  _descriptionInputFiled() => TextFormField(
    decoration: _inputDescDecoration("Description"),
    validator: (val) => _ifNull(val),
    style: _textStyle(),
    maxLines: 5,
    keyboardType: TextInputType.multiline,
    controller: description,
  );

  _placeInputFiled() => TextFormField(
    decoration: _inputDecoration("Lieu", "Lieu de l'événement", Icons.place),
    validator: (val) => _ifNull(val),
    style: _textStyle(),
    maxLines: 1,
    keyboardType: TextInputType.text,
    controller: place,
  );

  _prixInputFiled() => TextFormField(
    decoration: _inputDecoration("Prix", "0", Icons.euro_symbol),
    validator: (val) => _ifNull(val),
    style: _textStyle(),
    maxLines: 1,
    keyboardType: TextInputType.number,
    controller: price,
  );

  _venteInputFiled() => TextFormField(
    decoration: _inputDecoration("Lien de vente", "Lien de vente des places", Icons.payment),
    validator: (val) => _ifNull(val),
    style: _textStyle(),
    maxLines: 1,
    keyboardType: TextInputType.url,
    controller: link,
  );

  _fbInputFiled() => TextFormField(
    decoration: _inputDecoration("Lien Facebook", "Lien de l'événement sur facebook", Icons.link),
    validator: (val) => _ifNull(val),
    style: _textStyle(),
    maxLines: 1,
    keyboardType: TextInputType.url,
    controller: fblink,
  );

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

  _inputDescDecoration(label) => InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(18.0),
          borderSide: new BorderSide()),
      hintText:"BlaBlaBla",
      hintStyle: _hinttextStyle(),
  );

  _ifNull(val) {
    if (val.isEmpty) {
      return '*Champs requis';
    }
    return null;
  }

  _textStyle() => TextStyle(color: Colors.black, fontSize: 15.0,);
  _hinttextStyle() => TextStyle(color: Colors.black12, fontSize: 15.0,);

  void callDatePickerStart() async {
    var order = await getDate();
    var startTime = await getTime();
    setState(() {
      order = new DateTime(order.year, order.month, order.day, startTime.hour, startTime.minute);
      if(order.isAfter(DateTime.now()))
        startdate = order;
    });
  }

  void callDatePickerEnd() async {
    var order = await getDate();
    var endTime = await getTime();
    setState(() {
      order = new DateTime(order.year, order.month, order.day, endTime.hour, endTime.minute);
      if(order.isAfter(startdate))
        enddate = order;
    });

  }

  void callDatePickerPub() async {
    var order = await getDate();
    var pubTime = await getTime();
    setState(() {
      order = new DateTime(order.year, order.month, order.day, pubTime.hour, pubTime.minute);
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

  Future<TimeOfDay> getTime(){
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 0, minute: 0),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        },
    );

  }

  Container datetimeButton(String type) {
    String date;
    var color;
    var icon = Icons.access_time;

    if (type == 'start') {
      color = Colors.green;
      date = "  Début : " + DateFormat("EEE dd MMM yyyy - HH:mm","fr_FR").format(startdate);
    }
    else if (type == 'end') {
      color = Colors.red;
      date =  "  Fin : " + DateFormat("EEE dd MMM yyyy - HH:mm","fr_FR").format(enddate);
    }
    else if (type == 'publication') {
      color = Colors.orange;
      date =  "  Publication : " + DateFormat("EEE dd MMM yyyy - HH:mm","fr_FR").format(pubdate);
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