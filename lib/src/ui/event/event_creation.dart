import 'dart:io';

import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as Path;

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
// ignore: camel_case_types
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

  var start = DateTime.now();
  var end = DateTime.now();
  var pub = DateTime.now();

  File _image;
  String _uploadedFileURL = "null";

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
                      SizedBox(height: 10.0),
                      //Titre
                      CustomTextFormField(
                        "Nom de l'événement",
                        "Intitulé de l'évenement",
                        Icons.calendar_today,
                        titre,
                        type: "titre",
                        requiredField: true,
                        maxLength: 100,
                      ),
                      SizedBox(height: 10.0),
                      //Description
                      CustomTextFormField(
                        "Description",
                        "Description de votre évenement",
                        null,
                        description,
                        type: "desc",
                        requiredField: true,
                      ),
                      SizedBox(height: 10.0,),
                      //Dates
                      Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IntrinsicWidth(
                                child: Column(
                                  children: <Widget>[
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(200.0)),
                                      elevation: 2.0,
                                      onPressed: callDatePickerStart,
                                      child: dateButton("start"),
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10.0,),
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(200.0)),
                                      elevation: 2.0,
                                      onPressed: callDatePickerEnd,
                                      child: dateButton("end"),
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10.0,),
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(200.0)),
                                      elevation: 2.0,
                                      onPressed: callDatePickerPub,
                                      child: dateButton("publication"),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              IntrinsicWidth(
                                child: Column(
                                    children: <Widget>[
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(200.0)),
                                        elevation: 2.0,
                                        onPressed: callTimePickerStart,
                                        child: timeButton("start"),
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10.0,),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(200.0)),
                                        elevation: 2.0,
                                        onPressed: callTimePickerEnd,
                                        child: timeButton("end"),
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10.0,),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(200.0)),
                                        elevation: 2.0,
                                        onPressed: callTimePickerPub,
                                        child: timeButton("publication"),
                                        color: Colors.white,
                                      ),
                                    ]
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 10.0),
                      //Lieu
                      CustomTextFormField(
                        "Lieu",
                        "Lieu de l'évenement",
                        Icons.place,
                        place,
                        requiredField: true,
                      ),
                      SizedBox(height: 10.0),
                      //Prix
                      CustomTextFormField(
                        "Prix",
                        "0",
                        Icons.euro_symbol,
                        price,
                        keyboard : TextInputType.number,
                        requiredField: true,
                      ),
                      SizedBox(height: 10.0),
                      //Lien de vente
                      CustomTextFormField(
                        "Lien de vente",
                        "Lien de vente des places",
                        Icons.credit_card,
                        link,
                        keyboard : TextInputType.url,
                        maxLength: 500,
                      ),
                      SizedBox(height: 10.0),
                      //Lien facebook
                      CustomTextFormField(
                        "Lien Facebook",
                        "Lien de l'évent sur facebook",
                        FontAwesomeIcons.facebookSquare,
                        fblink,
                        keyboard : TextInputType.url,
                        maxLength: 500,
                      ),
                      SizedBox(height: 10.0),
                      //Image
                      _downloadImage(),
                      Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'créer'.toUpperCase(),
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  )),
                              splashColor: Colors.white,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  bloc.addSaveEvent(
                                      new EventModel(
                                          idEvent: 0,
                                          name: titre.text,
                                          startDate: start,
                                          endDate: end,
                                          place: place.text,
                                          backgroundUrl: _uploadedFileURL,
                                          description: description.text,
                                          publicationDate: pub,
                                          link: link.text,
                                          facebookLink: fblink.text,
                                          idClubRef: 100,
                                          enable: true,
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

  _downloadImage() => ButtonTheme(
      minWidth:MediaQuery.of(context).size.width,
      height: 50.0,
      padding: EdgeInsets.all(15.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        elevation: 3.0,
        onPressed: chooseFile,
        child:
        Container(
          child: Row(
              children: <Widget>[
                Icon(Icons.add_photo_alternate, size: 25, color: Colors.black38,),
                Text("   Importer la couverture de l'événement", style: TextStyle(color: Colors.black38, fontSize: 15,)),
              ]
          ),
        ),
        color: _verifImage(),
      )
  );

  Color _verifImage(){
    if(_image==null) return Colors.grey.withOpacity(0.7);
    else return Colors.green.withOpacity(0.7);
  }

  Future chooseFile() async {
    _image = null;
    _uploadedFileURL = null;
    await FilePicker.getFile(type: FileType.image).then((file) {
      setState(() {
        _image = file;
      });
      uploadFile();
    });
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('couv_event/${start.year}/${titre.text.replaceAll(' ', '_')}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  callDatePickerStart() async {
    var order = await getDate(start);
    setState(() {
      order = new DateTime(order.year, order.month, order.day, start.hour, start.minute);
      if(order.isAfter(DateTime.now())) {
        start = order;
        if(end.isBefore(start))
          end = start;
      }
    });
  }

  callTimePickerStart() async {
    var order = await getTime(start);
    var date = start;
    setState(() {
      order = new TimeOfDay(hour: order.hour, minute: order.minute);
      date = DateTime(start.year, start.month, start.day, order.hour, order.minute);
      if(date.isAfter(DateTime.now())) {
        start = date;
        if (end.isBefore(date))
          end = date;
      }
    });
  }

  callDatePickerEnd() async {
    var order = await getDate(end);
    setState(() {
      order = new DateTime(order.year, order.month, order.day, end.hour, end.minute);
      if(order.isAfter(start)) {
        end = order;
        if(end.isBefore(start))
          end = start;
      }
    });
  }

  callTimePickerEnd() async {
    var order = await getTime(end);
    var date = end;
    setState(() {
      order = new TimeOfDay(hour: order.hour, minute: order.minute);
      date = DateTime(end.year, end.month, end.day, order.hour, order.minute);
      if(date.isAfter(start)) {
        end = date;
        if(end.isBefore(start))
          end = start;
      }
    });
  }

  callDatePickerPub() async {
    var order = await getDate(pub);
    setState(() {
      order = new DateTime(order.year, order.month, order.day, start.hour, start.minute);
      if(order.isBefore(start)) {
        pub = order;
      }
    });
  }

  callTimePickerPub() async {
    var order = await getTime(pub);
    var date = pub;
    setState(() {
      order = new TimeOfDay(hour: order.hour, minute: order.minute);
      date = DateTime(pub.year, pub.month, pub.day, order.hour, order.minute);
      if(date.isBefore(start)) {
        pub = date;
      }
    });
  }

  Future<DateTime> getDate(DateTime date) {
    return showDatePicker(
      context: context,
      initialDate: date,
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

  Future<TimeOfDay> getTime(DateTime date){
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

  }

  Container dateButton(String type) {
    String date;
    var color;
    var icon = Icons.event;

    if (type == 'start') {
      color = Colors.green;
      date = "  Début : " + DateFormat("EEE dd MMM yyyy","fr_FR").format(start);
    }
    else if (type == 'end') {
      color = Colors.red;
      date =  "  Fin : " + DateFormat("EEE dd MMM yyyy","fr_FR").format(end);
    }
    else if (type == 'publication') {
      color = Colors.orange;
      date =  "  Publi : " + DateFormat("EEE dd MMM yyyy","fr_FR").format(pub);
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

  Container timeButton(String type) {
    String date;
    var color;
    var icon = Icons.access_time;

    if (type == 'start') {
      color = Colors.green;
      date = DateFormat("  HH:mm","fr_FR").format(start);
    }
    else if (type == 'end') {
      color = Colors.red;
      date = DateFormat("  HH:mm","fr_FR").format(end);
    }
    else if (type == 'publication') {
      color = Colors.orange;
      date = DateFormat("  HH:mm","fr_FR").format(pub);
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