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

class FairpayForm extends StatefulWidget {
  final String type;
  final ClubModel club;
  @required ClubsBloc clubsBloc;
  @required FairpayLogsBloc fairpayBloc;

  FairpayForm(this.type, this.club, {@required this.clubsBloc, @required this.fairpayBloc});

  @override
  fairpayFormState createState() {
    return fairpayFormState();
  }
}

class fairpayFormState extends State<FairpayForm> {

  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final descController = TextEditingController();
  final folderLinkController = TextEditingController();
  //final ClubsBloc clubsBloc = widget.bloc;
  //final FairpayLogsBloc fairpayLogsBloc = widget.fairpayBloc;

  @override Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 20.0,
      //backgroundColor: Theme.of(context).backgroundColor,
      child: Form(
          key: _formKey,
          child: _form()
      ),
    );
  }

  getColor() {
    if(Base.thisUser == null) return Colors.grey;
    switch (widget.type) {
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
    if(widget.type == "Retrait") return -amount;
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

  _form() =>
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
                        if(widget.type != "Subvention" && Base.thisUser != null) {
                          widget.club.solde += _getAmount();
                          widget.clubsBloc.add(ClubToBeSaved(club: widget.club));
                          widget.clubsBloc.add(ClubsRequested());
                        }
                        widget.fairpayBloc.add(FairpayLogToBeSaved(fairpayLog: FairpayLogModel(
                            type: widget.type,
                            amount: _getAmount(),
                            idClubRef: widget.club.idClubRef,
                            info: "${ Base.thisUser.firstname } ${ Base.thisUser.lastname } :: ${ descController.text } :: ${ folderLinkController.text ?? "" }"
                        )));
                        widget.fairpayBloc.add(FairpayLogsByClubRequested(id: widget.club.idClubRef.toString()));
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      }
                    }
                )
            )
          ]
      );
}