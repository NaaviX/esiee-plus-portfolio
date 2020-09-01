import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_info.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

class ProfList extends StatefulWidget {

  UnitModel selectedUnit;

  ProfList({this.selectedUnit});

  @override
  State<StatefulWidget> createState() {
    return ProfListState();
  }
}

class ProfListState extends State<ProfList> {
  final bloc = ProfsBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchAllProfs();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  final log = Logger('ProfList');

  @override
  Widget build(BuildContext context){
    return Scaffold(

        appBar: AppBar(
          title: widget.selectedUnit==null ? Text("Les professeurs") : Text(widget.selectedUnit.unitName),
        ),
        body: StreamBuilder(
          stream: bloc.allProfs,
          builder: (context, AsyncSnapshot<List<ProfModel>> snapshot) {
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

  Widget buildList(AsyncSnapshot<List<ProfModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
          if(widget.selectedUnit == null || snapshot.data[index].units.contains(widget.selectedUnit)) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: snapshot.data[index].urlPhoto != null && snapshot.data[index].urlPhoto != "null" ?
                    CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data[index].urlPhoto),
                      backgroundColor: Colors.white,
                      radius:50,
                    ) : Icon(Icons.person, color: Colors.white,),
                  ),
                  /*CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data[index].urlPhoto),
              ),*/
                  title: Text(snapshot.data[index].firstname+" "+snapshot.data[index].lastname, style: TextStyle(fontSize: 20, ),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfInfoPage(prof : snapshot.data[index])),
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