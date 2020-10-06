import 'dart:io';

import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CreateEventForm extends StatefulWidget {
  EventModel event;

  BuildContext context;
  EventsBloc bloc;

  TextEditingController titre, place, description, link, fblink, price;

  DateTime start, end, pub;
  String uploadedFileURL;

  bool isForStratif;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CreateEventForm({this.event}) {
    if (event != null) {
      this.event = this.event;
      this.titre = TextEditingController(text: this.event.name);
      this.place = TextEditingController(text: this.event.place,);
      this.description = TextEditingController(text: this.event.description,);
      this.link = TextEditingController(text: this.event.link,);
      this.fblink = TextEditingController(text: this.event.facebookLink,);
      this.price = TextEditingController(text: this.event.price.toString(),);
      this.isForStratif = this.event.enabledStratif;
      this.start = this.event.startDate;
      this.end = this.event.endDate;
      this.pub = this.event.publicationDate;
      this.uploadedFileURL = this.event.backgroundUrl;
    }
    else {
      this.titre = TextEditingController();
      this.place = TextEditingController();
      this.description = TextEditingController();
      this.link = TextEditingController();
      this.fblink = TextEditingController();
      this.price = TextEditingController();
      this.isForStratif = true;
      this.start = DateTime.now();
      this.end = DateTime.now();
      this.pub = DateTime.now();
      this.uploadedFileURL = "null";
    }
  }

  @override
  CreateEventFormState createState() => CreateEventFormState();
}

class CreateEventFormState extends State<CreateEventForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: widget.uploadedFileURL!=null && widget.uploadedFileURL!="null" ?
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstOut),
                        image: NetworkImage(widget.uploadedFileURL)
                    ),
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 50,
                  ),
                ) :
                Container(
                  color: Colors.black.withOpacity(0.3),
                  height: 150,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                onTap: chooseFile,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 20, top: 0, right: 20, bottom: 20),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 15.0),
                            //Titre
                            CustomTextFormField(
                              "Nom de l'événement",
                              "Intitulé de l'évenement",
                              Icons.calendar_today,
                              widget.titre,
                              type: "titre",
                              requiredField: true,
                              maxLength: 100,
                            ),
                            SizedBox(height: 15.0),
                            //Description
                            CustomTextFormField(
                              "Description",
                              "Description de votre évenement",
                              null,
                              widget.description,
                              type: "desc",
                              requiredField: true,
                            ),
                            SizedBox(height: 15.0,),
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
                                                borderRadius: BorderRadius.circular(
                                                    200.0)),
                                            elevation: 2.0,
                                            onPressed: callDatePickerStart,
                                            child: dateButton("start"),
                                            color: Theme.of(context).backgroundColor,
                                          ),
                                          SizedBox(height: 10.0,),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    200.0)),
                                            elevation: 2.0,
                                            onPressed: callDatePickerEnd,
                                            child: dateButton("end"),
                                            color: Theme.of(context).backgroundColor,
                                          ),
                                          SizedBox(height: 10.0,),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    200.0)),
                                            elevation: 2.0,
                                            onPressed: callDatePickerPub,
                                            child: dateButton("publication"),
                                            color: Theme.of(context).backgroundColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IntrinsicWidth(
                                      child: Column(
                                          children: <Widget>[
                                            RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(200.0)),
                                                elevation: 2.0,
                                                onPressed: callTimePickerStart,
                                                child: timeButton("start"),
                                                color: Theme.of(context).backgroundColor
                                            ),
                                            SizedBox(height: 10.0,),
                                            RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(200.0)),
                                              elevation: 2.0,
                                              onPressed: callTimePickerEnd,
                                              child: timeButton("end"),
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                            SizedBox(height: 10.0,),
                                            RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(200.0)),
                                              elevation: 2.0,
                                              onPressed: callTimePickerPub,
                                              child: timeButton("publication"),
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                          ]
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(height: 15.0),
                            //Lieu
                            CustomTextFormField(
                              "Lieu",
                              "Lieu de l'évenement",
                              Icons.place,
                              widget.place,
                              requiredField: true,
                            ),
                            SizedBox(height: 15.0),
                            //Prix
                            CustomTextFormField(
                              "Prix",
                              "0",
                              Icons.euro_symbol,
                              widget.price,
                              keyboard: TextInputType.number,
                              requiredField: true,
                            ),
                            SizedBox(height: 15.0),
                            //Lien de vente
                            CustomTextFormField(
                              "Lien de vente",
                              "Lien de vente des places",
                              Icons.credit_card,
                              widget.link,
                              keyboard: TextInputType.url,
                              maxLength: 500,
                            ),
                            SizedBox(height: 15.0),
                            //Lien facebook
                            CustomTextFormField(
                              "Lien Facebook",
                              "Lien de l'évent sur facebook",
                              FontAwesomeIcons.facebookSquare,
                              widget.fblink,
                              keyboard: TextInputType.url,
                              maxLength: 500,
                            ),
                            SizedBox(height: 15.0),
                            _stratif(),
                            SizedBox(height: 50.0),
                          ]
                      )
                  )
              )
            ],
          )
      ),
    );
  }

  _stratif() {
    return SwitchListTile(
      title:const Text('Administratifs admis'),
      value: widget.isForStratif,
      onChanged: (bool value)
      {
        setState( ()
        {
          widget.isForStratif = value;
        });
      },
      activeColor : Colors.green,
      inactiveThumbColor : Colors.red,
    );
  }

  File image;

  Future chooseFile() async {
    widget.uploadedFileURL = null;
    await FilePicker.getFile(type: FileType.image).then((file) {
      setState(() {
        image = file;
      });
      uploadFile();
    });
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('couv_event/${widget.start.year}/${widget.titre.text.replaceAll(' ', '_')}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        widget.uploadedFileURL = fileURL;
      });
    });
  }

  callDatePickerStart() async {
    var order = await getDate(widget.start);
    setState(() {
      order = new DateTime(
          order.year, order.month, order.day, widget.start.hour, widget.start.minute);
      if (order.isAfter(DateTime.now())) {
        widget.start = order;
        if (widget.end.isBefore(widget.start))
          widget.end = widget.start;
      }
    });
  }

  callTimePickerStart() async {
    var order = await getTime(widget.start);
    var date = widget.start;
    setState(() {
      order = new TimeOfDay(hour: order.hour, minute: order.minute);
      date = DateTime(
          widget.start.year, widget.start.month, widget.start.day, order.hour, order.minute);
      if (date.isAfter(DateTime.now())) {
        widget.start = date;
        if (widget.end.isBefore(date))
          widget.end = date;
      }
    });
  }

  callDatePickerEnd() async {
    var order = await getDate(widget.end);
    setState(() {
      order =
      new DateTime(order.year, order.month, order.day, widget.end.hour, widget.end.minute);
      if (order.isAfter(widget.start)) {
        widget.end = order;
        if (widget.end.isBefore(widget.start))
          widget.end = widget.start;
      }
    });
  }

  callTimePickerEnd() async {
    var order = await getTime(widget.end);
    var date = widget.end;
    setState(() {
      order = new TimeOfDay(hour: order.hour, minute: order.minute);
      date = DateTime(widget.end.year, widget.end.month, widget.end.day, order.hour, order.minute);
      if (date.isAfter(widget.start)) {
        widget.end = date;
        if (widget.end.isBefore(widget.start))
          widget.end = widget.start;
      }
    });
  }

  callDatePickerPub() async {
    var order = await getDate(widget.pub);
    setState(() {
      order = new DateTime(
          order.year, order.month, order.day, widget.start.hour, widget.start.minute);
      if (order.isBefore(widget.start)) {
        widget.pub = order;
      }
    });
  }

  callTimePickerPub() async {
    var order = await getTime(widget.pub);
    var date = widget.pub;
    setState(() {
      order = new TimeOfDay(hour: order.hour, minute: order.minute);
      date = DateTime(widget.pub.year, widget.pub.month, widget.pub.day, order.hour, order.minute);
      if (date.isBefore(widget.start)) {
        widget.pub = date;
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

  Future<TimeOfDay> getTime(DateTime date) {
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
      date =
          "  Début : " + DateFormat("EEE dd MMM yyyy", "fr_FR").format(widget.start);
    }
    else if (type == 'end') {
      color = Colors.red;
      date = "  Fin : " + DateFormat("EEE dd MMM yyyy", "fr_FR").format(widget.end);
    }
    else if (type == 'publication') {
      color = Colors.orange;
      date = "  Publi : " + DateFormat("EEE dd MMM yyyy", "fr_FR").format(widget.pub);
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
      date = DateFormat("  HH:mm", "fr_FR").format(widget.start);
    }
    else if (type == 'end') {
      color = Colors.red;
      date = DateFormat("  HH:mm", "fr_FR").format(widget.end);
    }
    else if (type == 'publication') {
      color = Colors.orange;
      date = DateFormat("  HH:mm", "fr_FR").format(widget.pub);
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