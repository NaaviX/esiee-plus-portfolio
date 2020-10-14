import 'package:bde_esiee_mobile/src/blocs/prof_event.dart';
import 'package:bde_esiee_mobile/src/blocs/prof_state.dart';
import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ProfList extends StatefulWidget {

  UnitModel selectedUnit;


  ProfList({this.selectedUnit});

  @override
  State<StatefulWidget> createState() {
    return ProfListState();
  }
}

class ProfListState extends State<ProfList> {

  @override
  void initState() {
    BlocProvider.of<ProfsBloc>(context)
        .add(ProfsRequested());
    super.initState();
  }

  final log = Logger('ProfList');

  @override
  Widget build(BuildContext context){
    return Scaffold(

        appBar: AppBar(
          title: widget.selectedUnit==null ? Text("Les professeurs") : Text(widget.selectedUnit.unitName),
        ),
        body: BlocBuilder<ProfsBloc, ProfState>(
            builder: (context, state) {
              if (state is ProfsInitial) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is ProfsLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is ProfsLoadSuccess) {
                final profs = state.profs;

                return buildList(profs);
              }
              if (state is ProfsLoadFailure) {
                return Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Container();
            })

    );
  }

  Widget buildList(List<ProfModel> profs) {
    return ListView.builder(
        itemCount: profs.length,
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
          if(widget.selectedUnit == null || profs[index].units.contains(widget.selectedUnit)) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: profs[index].urlPhoto != null && profs[index].urlPhoto != "null" ?
                    CircleAvatar(
                      backgroundImage: NetworkImage(profs[index].urlPhoto),
                      backgroundColor: Colors.white,
                      radius:50,
                    ) : Icon(Icons.person, color: Colors.white,),
                  ),
                  /*CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data[index].urlPhoto),
              ),*/
                  title: Text(profs[index].firstname+" "+profs[index].lastname, style: TextStyle(fontSize: 20, ),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfInfoPage(prof : profs[index])),
                    );
                  },
                ),
                Container(child: Divider(color: Colors.black,)),
              ],
            );
          }
          else return Container();
        });
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }

}