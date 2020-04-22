import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/fairpay_log_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class FairPayManager extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FairPayManagerState();
  }
}

class FairPayManagerState extends State<FairPayManager> {
  final clubsBloc = ClubsBloc();
  final fairPayBloc = FairpayLogBloc();

  @override
  void initState() {
    super.initState();
    clubsBloc.fetchAllClubs();
  }

  @override
  void dispose() {
    clubsBloc.dispose();
    super.dispose();
  }

  final log = Logger('clubList');

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestion Fairpay"),
        ),
        body: StreamBuilder(
          stream: clubsBloc.allClubs,
          builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
            if (snapshot.hasData) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }

  GridView buildList( AsyncSnapshot<List<ClubModel>> snapshot ){
    return new GridView.count(
      crossAxisCount: 3,
      children: new List<Widget>.generate(snapshot.data.length, (index) {
        return _clubTile(snapshot.data[index]);
      }),
    );
  }

  Widget _clubTile(ClubModel club) => GestureDetector(
      child: Padding(
          padding: EdgeInsets.only(top: 4.0, bottom: 12.0),
          child: GridTile(
            child: Column(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(club.urlPhoto), radius: 50, backgroundColor: Colors.grey.withOpacity(0.1)),
                  Padding(padding: EdgeInsets.all(1.0)),
                  Text( "${club.solde} €", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey))
                ]
            ),
          )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FairPayClubManager(club)),
        );
      }
  );

  String formatClubName(String clubName){
    switch (clubName) {
      case "Club esiee sans frontières":
        return "ESF";
      case "Bureau des Sports":
        return "BDS";
      case "Bureau des étudiants":
        return "BDE";
      case "Club dj":
        return "DJ";
      default:
        return clubName.replaceAll("Club ","").toUpperCase();
    }
  }
}

//When user click on a club
class ClubFairPayPage extends StatelessWidget{

  final ClubModel club;
  ClubFairPayPage({this.club});

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(club.name),
      ),
      body: Center(
          child: Image.network(
            club.urlPhoto,
          )
      ),
    );
  }
}

class FairPayClubManager extends StatefulWidget {

  final ClubModel thisClub;
  const FairPayClubManager(this.thisClub);

  @override
  State<StatefulWidget> createState() {
    return FairPayClubManagerState();
  }
}

class FairPayClubManagerState extends State<FairPayClubManager>{
  final Logbloc = FairpayLogBloc();

  @override
  void initState() {
    super.initState();
    Logbloc.fetchClubLogs(widget.thisClub.idClubRef.toString());
  }

  @override
  void dispose() {
    Logbloc.dispose();
    super.dispose();
  }

  final log = Logger('Fairpay Club');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.thisClub.name.toString()),
        ),
        body: StreamBuilder(
          stream: Logbloc.ClubFairpayLog,
          builder: (context, AsyncSnapshot<List<FairpayLogModel>> snapshot) {
            if (snapshot.hasData){
              return Column(
                  children: <Widget>[
                    topArea(),
                    Expanded(
                        child: buildList(snapshot)
                    )
                  ]
              );
            }
            else if (snapshot.hasError) {
              return
                Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  Card topArea() => Card(
    margin: EdgeInsets.all(10.0),
    elevation: 1.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
    child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5.0)),
            CircleAvatar(backgroundImage: NetworkImage(widget.thisClub.urlPhoto), radius: 50, backgroundColor: Colors.grey.withOpacity(0.1)),
            Center(
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("  ${widget.thisClub.solde} €",
                      style: TextStyle(color: getColor(widget.thisClub.solde), fontSize: 30.0, fontWeight: FontWeight.bold))
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                cardButton("Depot", Colors.green),
                cardButton("Retrait", Colors.red),
                //cardButton("Subv.", Colors.orangeAccent)
              ],
            )
          ],
        )),
  );

  getColor(double solde){
    return solde > 0 ? Colors.blueAccent : solde < 0 ? Colors.redAccent : Colors.grey;
  }

  FlatButton cardButton(String title, Color color, ) => FlatButton(
      child: Text(title, style: TextStyle(color: Colors.white),),
      color: color,
      onPressed: () {
        showDialog<void>(
            context: context,
            barrierDismissible: true,
            // user must tap button!
            builder: (BuildContext context) {
              return fairPayActionForm(title, widget.thisClub);
            }
        );
      }
  );

  Widget buildList(AsyncSnapshot<List<FairpayLogModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return transactionRow(snapshot.data[index], oddColour: (index % 2 == 0) ? Color(0xFFF7F7F9) : Colors.white);
        }
    );
  }

  Container transactionRow( FairpayLogModel log, {Color oddColour = Colors.white} ) => Container(
    decoration: BoxDecoration(color: oddColour),
    padding: EdgeInsets.only(top: 15.0, bottom: 10.0, left: 5.0, right: 5.0),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(DateFormat('d MMM').format(log.date), style: TextStyle(color: Colors.grey, fontSize: 14.0)),
            Text(nameToInitial(log.userName), style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 12.0))
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 15.0),
            transIcon(log.amount),
            transText(log.amount),
            SizedBox(width: 25.0),
            Text(log.description, style: TextStyle(fontSize: 16.0))
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );

  String nameToInitial(String name){
    return name == "unknown" ? "" : "${name.split(" ")[0][0]}. ${name.split(" ")[1]}";
  }

  Widget transIcon(double amount){
    int quarter = amount < 0 ? 1 : 0;
    Color color = amount < 0 ? Colors.red : Colors.green;
    return RotatedBox(
        quarterTurns: quarter,
        child: Icon(Icons.call_made, color: color));
  }

  Widget transText(double amount){
    Color color = amount < 0 ? Colors.red : Colors.green;
    String text = amount < 0 ? amount.toStringAsFixed(2) : '+'+amount.toStringAsFixed(2);
    return Text(text.padRight(8,'  '), style: TextStyle(fontSize: 16.0, color: color, fontWeight: FontWeight.bold ));
  }


}

class fairPayActionForm extends StatefulWidget{
  final String type;
  final ClubModel club;
  fairPayActionForm(this.type, this.club);

  @override
  State<StatefulWidget> createState() {
    return fairPayActionFormState();
  }
}

class fairPayActionFormState extends State<fairPayActionForm>{
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
      elevation: 10.0,
      backgroundColor: Colors.white,
      child: Form(
          key: _formKey,
          child: dialogContent(context)
      ),
    );
  }

  dialogContent(BuildContext context) {
    switch(widget.type){
      case "Depot":
        return _depotForm(context);
      case "Retrait":
        return _retraitForm();
    /*case "Subv.":
        return _subventionForm();*/
    }
  }

  _amountInput() => Container(
      padding: EdgeInsets.only(right: 25.0, left: 25.0, top: 30.0, bottom: 10.0),
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

  _descriptionInput() => Container(
      padding: EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0, bottom: 10.0),
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

  _linkInput() => Container(
      padding: EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0, bottom: 10.0),
      alignment: Alignment.topCenter,
      child: CustomTextFormField(
        "Lien dossier",
        "...",
        Icons.picture_as_pdf,
        TextEditingController(),
        requiredField: true,
      )
  );

  _depotForm(BuildContext context) => Wrap(
      children: <Widget>[
        _amountInput(),
        _descriptionInput(),
        Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: FlatButton(
                child: Text("Depot", style: TextStyle(color: Colors.white),),
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    clubsBloc.editSolde(widget.club, double.parse(amountController.text));
                    fairpayBloc.addLog(
                        FairpayLogModel(
                            type: "Depot",
                            amount: double.parse(amountController.text),
                            idClubRef: widget.club.idClubRef,
                            info: "${Base.thisUser.firstname} ${Base.thisUser.lastname} :: ${descController.text}"
                        )
                    );
                    if(Navigator.canPop(context)) Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return FairPayClubManager(widget.club);
                    }));
                  }
                }
            ))
      ]
  );

  _retraitForm() => Wrap(
      children: <Widget>[
        _amountInput(),
        _descriptionInput(),
        Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: FlatButton(
                child: Text("Retrait", style: TextStyle(color: Colors.white),),
                color: Colors.red,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    clubsBloc.editSolde(widget.club, -double.parse(amountController.text));
                    fairpayBloc.addLog(
                        FairpayLogModel(
                            type: "Depot",
                            amount: -double.parse(amountController.text),
                            idClubRef: widget.club.idClubRef,
                            info: "${Base.thisUser.firstname} ${Base.thisUser.lastname} :: ${descController.text}"
                        )
                    );
                    if(Navigator.canPop(context)) Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return FairPayClubManager(widget.club);
                    }));
                  }
                }
            ))]);

  _subventionForm() => Wrap(
      children: <Widget>[
        _amountInput(),
        _descriptionInput(),
        _linkInput(),
        Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: FlatButton(
                child: Text("Subv.", style: TextStyle(color: Colors.white)),
                color: Colors.orangeAccent,
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      // user must tap button!
                      builder: (BuildContext context) {
                        return fairPayActionForm("Subv.",widget.club);
                      }
                  );
                }
            ))]);

}

