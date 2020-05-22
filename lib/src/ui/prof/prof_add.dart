import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_add_form.dart';
import 'package:flutter/material.dart';

import '../../App.dart';

class AddProf extends StatefulWidget {
  addProfForm form;

  AddProf({ProfModel prof}){
    if(prof != null) this.form = addProfForm(prof: prof,);
    else form = addProfForm();
  }

  @override
  State<StatefulWidget> createState() {
    return AddProfState();
  }
}
class AddProfState extends State<AddProf> {

  final bloc = ProfsBloc();

  @override Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text("Nouveau Professeur")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15,),
            Image(image: AssetImage('assets/addTeacher.png'),width: MediaQuery.of(context).size.width,),
            SizedBox(height: 15,),
            widget.form,
            SizedBox(
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        200.0)
                ),
                elevation: 2.0,
                onPressed: () {
                  if (widget.form.formKey.currentState.validate()) {
                        ProfModel prof = new ProfModel(
                          idProf: idProf(),
                          firstname: widget.form.firstname.text,
                          lastname: widget.form.lastname.text,
                          mailEsiee: widget.form.mailEsiee.text,
                          phone: widget.form.phone.text,
                          office: widget.form.office.text,
                          units: widget.form.selectedChoices,
                          urlPhoto: verifURL(),
                        );
                        bloc.addSaveProf(prof);
                        Navigator.of(context).pop();
                  }
                },
                child: Text("Enregistrer", style: TextStyle(color: Colors.white, fontSize: 15),),
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  verifURL() {
    if(widget.form.uploadedFileURL != null) return widget.form.uploadedFileURL;
    else return "null";
  }

  idProf() {
    if(widget.form.prof != null) return widget.form.prof.idProf;
    else return 0;
  }
}