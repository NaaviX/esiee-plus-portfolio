import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/club_event.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_event.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'club_fairpay.dart';
import 'package:meta/meta.dart';

fairpayForm(FairpayState parent, String type, ClubModel club, {@required ClubsBloc bloc, @required FairpayLogsBloc fairpayBloc}) {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final descController = TextEditingController();
  final folderLinkController = TextEditingController();
  final ClubsBloc clubsBloc = bloc;
  final FairpayLogsBloc fairpayLogsBloc = fairpayBloc;

  getColor() {
    if(Base.thisUser == null) return Colors.grey;
    switch (type) {
      case "Depot":
        return Colors.green;
      case "Retrait":
        return Colors.red;
      case "Subvention":
        return Colors.orange;
    }
    return Colors.grey;
  }

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
    if(type == "Retrait") return -amount;
    else return amount;
  }

  _linkInput() =>
      Container(
          padding: EdgeInsets.only(
              right: 25.0, left: 25.0, top: 10.0, bottom: 10.0),
          alignment: Alignment.topCenter,
          child: CustomTextFormField(
            "Lien dossier",
            "...",
            Icons.picture_as_pdf,
            folderLinkController,
            requiredField: false,
          )
      );

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

  _form(BuildContext context) =>
      Wrap(
          children: <Widget>[
            _amountInput(),
            type == "Subvention" ? _linkInput() : Container(),
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
                      type, style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if(type != "Subvention" && Base.thisUser != null) {
                          club.solde += _getAmount();
                          clubsBloc.add(ClubToBeSaved(club: club));
                          clubsBloc.add(ClubsRequested());
                        }
                        fairpayBloc.add(FairpayLogToBeSaved(fairpayLog: FairpayLogModel(
                            type: type,
                            amount: _getAmount(),
                            idClubRef: club.idClubRef,
                            info: "${ Base.thisUser.firstname } ${ Base.thisUser.lastname } :: ${ descController.text } :: ${ folderLinkController.text ?? "" }"
                        )));
                        fairpayBloc.add(FairpayLogsByClubRequested(id: club.idClubRef.toString()));
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      }
                    }
                )
            )
          ]
      );

  return showDialog<void>(
      context: parent.context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 20.0,
          //backgroundColor: Theme.of(context).backgroundColor,
          child: Form(
              key: _formKey,
              child: _form(context)
          ),
        );
      }
  );
}