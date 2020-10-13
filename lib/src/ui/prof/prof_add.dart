import 'package:bde_esiee_mobile/src/blocs/prof_event.dart';
import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_bloc.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/resources/unit_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/unit_repository.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_add_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class AddProf extends StatefulWidget {
  ProfModel thisProf;
  final UnitsBloc unitsBloc;
  AddProf({Key key, ProfModel thisProf, @required this.unitsBloc});

  @override
  State<StatefulWidget> createState() {
    return AddProfState();
  }
}
class AddProfState extends State<AddProf> {
  AddProfForm form;

  @override
  void initState() {
    (widget.thisProf != null) ? form = AddProfForm(prof: widget.thisProf, parent: this)
        : form = AddProfForm(parent: this);
    super.initState();
  }

  @override Widget build(BuildContext context) {
    final UnitRepository unitRepository = UnitRepository(
      unitApiProvider: UnitApiProvider(
        client: Client(),
      ),
    );
    return new Scaffold(
      appBar: AppBar(
          title: Text("Nouveau Professeur")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5,),
            Image(image: AssetImage('assets/illustration/addTeacher.webp'),height: MediaQuery.of(context).size.height/6,),
            SizedBox(height: 5,),
            BlocProvider<UnitsBloc>(
                create: (BuildContext context) =>
                    UnitsBloc(unitRepository: unitRepository),
                child: form),
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
                        BlocProvider.of<ProfsBloc>(context)
                            .add(ProfToBeSaved(prof: prof));
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