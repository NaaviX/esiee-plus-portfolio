import 'dart:io';

import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_bloc.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class addProfForm extends StatefulWidget {
  ProfModel prof;

  BuildContext context;
  ProfsBloc bloc;

  TextEditingController firstname, lastname, mailEsiee, phone, office;

  String uploadedFileURL;
  List<UnitModel> selectedChoices;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  addProfForm({this.prof}) {
    if (this.prof != null) {
      this.prof = this.prof;
      this.firstname = TextEditingController(text: this.prof.firstname);
      this.lastname = TextEditingController(text: this.prof.lastname,);
      this.mailEsiee = TextEditingController(text: this.prof.mailEsiee,);
      this.phone = TextEditingController(text: this.prof.phone,);
      this.office = TextEditingController(text: this.prof.office,);
      this.uploadedFileURL = this.prof.urlPhoto;
      this.prof.units.forEach((element) {this.selectedChoices.add(element);});
    }
    else {
      this.firstname = TextEditingController();
      this.lastname = TextEditingController();
      this.mailEsiee = TextEditingController();
      this.phone = TextEditingController();
      this.office = TextEditingController();
      this.uploadedFileURL = "null";
      this.selectedChoices = List<UnitModel>();
    }
  }

  @override
  addProfFormState createState() => addProfFormState();
}

class addProfFormState extends State<addProfForm> {

  UnitBloc units = UnitBloc();

  @override
  void initState() {
    units.fetchAllUnits();
    super.initState();
  }

  @override
  void dispose() {
    units.dispose();
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
                  left: 20, top: 0, right: 20, bottom: 20),
              child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        //Nom
                        CustomTextFormField(
                          "Nom",
                          "Dupont",
                          null,
                          widget.lastname,
                          type: "titre",
                          //requiredField: true,
                          maxLength: 50,
                        ),
                        SizedBox(height: 15.0),
                        //Prénom
                        CustomTextFormField(
                          "Prénom",
                          "Jean",
                          null,
                          widget.firstname,
                          type: "titre",
                          //requiredField: true,
                          maxLength: 50,
                        ),
                        SizedBox(height: 15.0),
                        //Mail
                        CustomTextFormField(
                          "Mail ESIEE",
                          "prenom.nom@esiee.fr",
                          Icons.mail,
                          widget.mailEsiee,
                          keyboard: TextInputType.emailAddress,
                          //requiredField: true,
                          maxLength: 100,
                        ),
                        SizedBox(height: 15.0),
                        //phone
                        CustomTextFormField(
                          "N° de téléphone ESIEE",
                          "01 45 92 6X XX",
                          Icons.phone,
                          widget.phone,
                          keyboard: TextInputType.phone,
                          maxLength: 12,
                        ),
                        SizedBox(height: 15.0),
                        //bureau
                        CustomTextFormField(
                          "Bureau",
                          "1257",
                          Icons.place,
                          widget.office,
                          maxLength: 500,
                        ),
                        SizedBox(height: 15.0),
                        StreamBuilder(
                            stream: units.allUnits,
                            builder: (context, AsyncSnapshot<List<UnitModel>> snapshot) {
                              if(snapshot.hasData) return Wrap(
                                children: _buildChoiceList(snapshot.data),
                              );
                              else return CircularProgressIndicator();
                            }
                        ),
                        Text(widget.selectedChoices.toString()),
                        //listUnits(),
                        SizedBox(height: 15.0),
                        //Image
                        //_downloadImage(),
                        SizedBox(height: 15.0),
                      ]
                  )
              )
          )
      ),
    );
  }

  listUnits(){
    StreamBuilder(
        stream: units.allUnits,
        builder: (context, AsyncSnapshot<List<UnitModel>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    //scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Text(snapshot.data[index].unitName),
                        );
                      }
                  ),
                ),
              ],
            );
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        }
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

  File image;

  Color _verifImage() {
    if (image == null)
      return Colors.grey.withOpacity(0.7);
    else
      return Colors.green.withOpacity(0.7);
  }

  Future chooseFile() async {
    image = null;
    widget.uploadedFileURL = null;
    await FilePicker.getFile(type: FileType.image).then((file) {
      setState(() {
        image = file;
      });
      uploadFile();
    });
  }

  Future uploadFile() async {
    String nomFichier;
    widget.lastname.text.length >= 7 ?
    nomFichier = widget.lastname.text.substring(0, 7)+widget.firstname.text.substring(0, 0) :
    nomFichier = widget.lastname.text+widget.firstname.text.substring(0, 0);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('prof/${nomFichier}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        widget.uploadedFileURL = fileURL;
      });
    });
  }

  List<UnitModel> allUnits() {
    List<UnitModel> unitsList = List<UnitModel>();
    StreamBuilder(
        stream: units.allUnits,
        // ignore: missing_return
        builder: (context, AsyncSnapshot<List<UnitModel>> snapshot) {
          if (snapshot.hasData) {
            unitsList = snapshot.data;
          }
          else unitsList = [];
        }
    );
    return unitsList;
  }

  List<Widget> _buildChoiceList(List<UnitModel> units) {
    List<Widget> choices = List<Widget>();

    units.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.unitName),
          selected: widget.selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              widget.selectedChoices.contains(item)
                  ? widget.selectedChoices.remove(item)
                  : widget.selectedChoices.add(item);
              widget.selectedChoices.sort();
            });
          },
        ),
      ));
    });

    return choices;
  }
}