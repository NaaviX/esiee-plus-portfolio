import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';

import 'club_fairpay.dart';

class FairpayForm extends StatefulWidget {

  ClubModel club;
  String type;

  FairpayForm(this.type, this.club);

  @override
  FairpayFormState createState() => FairpayFormState();
}

class FairpayFormState extends State<FairpayForm> {
  final clubsBloc = ClubsBloc();
  final fairpayBloc = FairpayLogBloc();

  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 20.0,
      backgroundColor: Colors.white,
      child: Form(
          key: _formKey,
          child: _form(context)
      ),
    );
  }

  getColor() {
    switch (widget.type) {
      case "Depot":
        return Colors.green;
      case "Retrait":
        return Colors.red;
      case "Subvention":
        return Colors.orange;
    }
  }

  _form(BuildContext context) =>
      Wrap(
          children: <Widget>[
            _amountInput(),
            widget.type == "Subvention" ? _linkInput() : Container(),
            _descriptionInput(),
            Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: getColor(),
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      widget.type, style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if(widget.type != "Subvention") clubsBloc.editSolde(widget.club, _getAmount());
                        fairpayBloc.addLog(
                            FairpayLogModel(
                                type: widget.type,
                                amount: _getAmount(),
                                idClubRef: widget.club.idClubRef,
                                info: "${Base.thisUser.firstname} ${Base
                                    .thisUser.lastname} :: ${descController
                                    .text}"
                            )
                        );
                        if (Navigator.canPop(context)) Navigator.pop(context);
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) {
                          return Fairpay(club : widget.club, isTrez : true);
                        }));
                      }
                    }
                )
            )
          ]
      );

  _amountInput() =>
      Container(
          padding: EdgeInsets.only(
              right: 25.0, left: 25.0, top: 30.0, bottom: 10.0),
          alignment: Alignment.topCenter,
          child: CustomTextFormField(
            "Montant",
            "1.00",
            Icons.euro_symbol,
            amountController,
            requiredField: true,
            isPositive: true,
          )
      );

  _getAmount() {
    double amount = double.parse(amountController.text);
    if(widget.type == "Retrait") return -amount;
    else return amount;
  }

  _descriptionInput() =>
      Container(
          padding: EdgeInsets.only(
              right: 25.0, left: 25.0, top: 10.0, bottom: 10.0),
          alignment: Alignment.topCenter,
          child: CustomTextFormField(
              "Description",
              "...",
              Icons.insert_comment,
              descController,
              requiredField: true,
              type: "desc"
          )
      );

  _linkInput() =>
      Container(
          padding: EdgeInsets.only(
              right: 25.0, left: 25.0, top: 10.0, bottom: 10.0),
          alignment: Alignment.topCenter,
          child: CustomTextFormField(
            "Lien dossier",
            "...",
            Icons.picture_as_pdf,
            TextEditingController(),
            requiredField: true,
          )
      );
}