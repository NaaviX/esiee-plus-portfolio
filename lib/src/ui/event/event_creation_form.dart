import 'dart:io';

import 'package:bde_esiee_mobile/src/blocs/events_bloc.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class createEventForm extends StatefulWidget {
  BuildContext context;
  EventsBloc bloc;

  TextEditingController titre, place, description, link, fblink, price;

  GlobalKey<FormState> formKey;

  DateTime start, end, pub;
  File image;
  String uploadedFileURL;

  createEventForm({BuildContext context, EventsBloc bloc, TextEditingController titre, TextEditingController place, TextEditingController description,
      TextEditingController link, TextEditingController fblink, TextEditingController price, GlobalKey<FormState> formKey,
      DateTime start, DateTime end, DateTime pub, File image, String uploadedFileURL}){

    if(this.bloc != null) this.bloc = this.bloc;
    else this.bloc = EventsBloc();

    if(this.titre != null) this.titre = this.titre;
    else this.titre = TextEditingController();
    if(this.place != null) this.place = this.place;
    else this.place = TextEditingController();
    if(this.description != null) this.description = this.description;
    else this.description = TextEditingController();
    if(this.link != null) this.link = this.link;
    else this.link = TextEditingController();
    if(this.fblink != null) this.fblink = this.fblink;
    else this.fblink = TextEditingController();
    if(this.price != null) this.price = this.price;
    else this.price = TextEditingController();
    if(this.formKey != null) this.formKey = this.formKey;
    else this.formKey = GlobalKey<FormState>();
    if(this.start != null) this.start = this.start;
    else this.start = DateTime.now();
    if(this.end != null) this.end = this.end;
    else this.end = DateTime.now();
    if(this.pub != null) this.pub = this.pub;
    else this.pub = DateTime.now();
    if(this.uploadedFileURL != null) this.uploadedFileURL = this.uploadedFileURL;
    else this.uploadedFileURL = "null";
  }
  @override
  _createEventFormState createState() => _createEventFormState();
}

class _createEventFormState extends State<createEventForm> {
 @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    widget.titre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 0),
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
                          widget.titre,
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
                          widget.description,
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
                                            borderRadius: BorderRadius.circular(
                                                200.0)),
                                        elevation: 2.0,
                                        onPressed: callDatePickerStart,
                                        child: dateButton("start"),
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10.0,),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                200.0)),
                                        elevation: 2.0,
                                        onPressed: callDatePickerEnd,
                                        child: dateButton("end"),
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10.0,),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                200.0)),
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
                                              borderRadius: BorderRadius
                                                  .circular(200.0)),
                                          elevation: 2.0,
                                          onPressed: callTimePickerStart,
                                          child: timeButton("start"),
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 10.0,),
                                        RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(200.0)),
                                          elevation: 2.0,
                                          onPressed: callTimePickerEnd,
                                          child: timeButton("end"),
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 10.0,),
                                        RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(200.0)),
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
                          widget.place,
                          requiredField: true,
                        ),
                        SizedBox(height: 10.0),
                        //Prix
                        CustomTextFormField(
                          "Prix",
                          "0",
                          Icons.euro_symbol,
                          widget.price,
                          keyboard: TextInputType.number,
                          requiredField: true,
                        ),
                        SizedBox(height: 10.0),
                        //Lien de vente
                        CustomTextFormField(
                          "Lien de vente",
                          "Lien de vente des places",
                          Icons.credit_card,
                          widget.link,
                          keyboard: TextInputType.url,
                          maxLength: 500,
                        ),
                        SizedBox(height: 10.0),
                        //Lien facebook
                        CustomTextFormField(
                          "Lien Facebook",
                          "Lien de l'évent sur facebook",
                          FontAwesomeIcons.facebookSquare,
                          widget.fblink,
                          keyboard: TextInputType.url,
                          maxLength: 500,
                        ),
                        SizedBox(height: 10.0),
                        //Image
                        _downloadImage(),
                      ]
                  )
              )
          )
      ),
    );
  }

  _downloadImage() =>
      ButtonTheme(
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
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
                    Icon(Icons.add_photo_alternate, size: 25,
                      color: Colors.black38,),
                    Text("   Importer la couverture de l'événement",
                        style: TextStyle(color: Colors.black38, fontSize: 15,)),
                  ]
              ),
            ),
            color: _verifImage(),
          )
      );

  Color _verifImage() {
    if (widget.image == null)
      return Colors.grey.withOpacity(0.7);
    else
      return Colors.green.withOpacity(0.7);
  }

  Future chooseFile() async {
    widget.image = null;
    widget.uploadedFileURL = null;
    await FilePicker.getFile(type: FileType.image).then((file) {
      setState(() {
        widget.image = file;
      });
      uploadFile();
    });
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('couv_event/${widget.start.year}/${widget.titre.text.replaceAll(' ', '_')}');
    StorageUploadTask uploadTask = storageReference.putFile(widget.image);
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