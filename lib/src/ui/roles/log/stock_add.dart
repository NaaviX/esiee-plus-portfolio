import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/ui/roles/log/stock_add_form.dart';
import 'package:flutter/material.dart';

class AddStock extends StatefulWidget {
  ProfModel thisProf;
  AddStock();

  @override
  State<StatefulWidget> createState() {
    return AddStockState();
  }
}
class AddStockState extends State<AddStock> {

  final bloc = ProfsBloc();
  addProfForm form;

  @override
  void initState() {

  }

  @override Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text("Nouveau Professeur")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5,),
            Image(image: AssetImage('assets/addTeacher.png'),height: MediaQuery.of(context).size.height/6,),
            SizedBox(height: 5,),
            form,
            SizedBox(
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        200.0)
                ),
                elevation: 2.0,
                onPressed: () {
                  if (form.formKey.currentState.validate()) {
                    ProfModel prof = new ProfModel(
                      idProf: idProf(),
                      firstname: form.firstname.text,
                      lastname: form.lastname.text,
                      mailEsiee: form.mailEsiee.text,
                      phone: form.phone.text,
                      office: form.office.text,
                      units: form.selectedChoices.toList(),
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
    if(form.uploadedFileURL != null) return form.uploadedFileURL;
    else return "null";
  }

  idProf() {
    if(form.prof != null) return form.prof.idProf;
    else return 0;
  }
}