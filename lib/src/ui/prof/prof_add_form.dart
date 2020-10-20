import 'dart:collection';
import 'dart:io';

import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_event.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_state.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_add.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class AddProfForm extends StatefulWidget {
  ProfModel prof;

  BuildContext context;
  ProfsBloc bloc;

  TextEditingController firstname, lastname, mailEsiee, phone, office;

  String uploadedFileURL;
  Set<UnitModel> selectedChoices;
  AddProfState parent;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddProfForm({this.prof, AddProfState parent} ) {
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
      this.selectedChoices = HashSet<UnitModel>();
    }
  }

  @override
  AddProfFormState createState() => AddProfFormState();
}

class AddProfFormState extends State<AddProfForm> {

  @override
  void initState() {
    BlocProvider.of<UnitsBloc>(context).add(UnitsRequested());
    super.initState();
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
                          requiredField: true,
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
                          requiredField: true,
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
                          requiredField: true,
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
                        Center(
                          child: BlocBuilder<UnitsBloc, UnitState>(
                              builder: (context, state) {
                                if (state is UnitsInitial) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (state is UnitsLoadInProgress) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (state is UnitsLoadSuccess) {
                                  final units = state.units;
                                  return Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    spacing: 10,
                                    children: _buildChoiceList(units),
                                  );
                                }
                                if (state is UnitsLoadFailure) {
                                  return Text(
                                    'Something went wrong!',
                                    style: TextStyle(color: Colors.red),
                                  );
                                }
                                return Container();
                              }),
                        ),
                      ]
                  )
              )
          )
      ),
    );
  }


  File image;

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
        .child('prof/$nomFichier');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        widget.uploadedFileURL = fileURL;
      });
    });
  }

  List<Widget> _buildChoiceList(List<UnitModel> units) {
    List<Widget> choices = List<Widget>();

    units.forEach((item) {
      choices.add(
          Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              label: Text(item.unitName),
              selected: widget.selectedChoices.contains(item),
              backgroundColor: MyTheme.colorTheme(context, colorLight: Colors.grey.shade300, colorDark: MyTheme.PrimaryColorLight.withOpacity(0.3)),//Theme.of(context).accentColor,
              selectedColor: Theme.of(context).accentColor.withOpacity(0.5),
              labelStyle: TextStyle(color: MyTheme.colorTheme(context)),
              onSelected: (selected) {
                setState(() {
                  widget.selectedChoices.contains(item)
                      ? widget.selectedChoices.remove(item)
                      : widget.selectedChoices.add(item);
                });
              },
            ),
          ));
    });

    return choices;
  }
}