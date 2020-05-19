import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

class ProfList extends StatefulWidget {
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
          title: Text("Les professeurs"),
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
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data[index].urlPhoto),
            ),
            title: Text(snapshot.data[index].firstname+" "+snapshot.data[index].lastname),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfInfoPage(prof : snapshot.data[index])),
              );
            },
          );
        });
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }



}

//When user click on a club
class ProfInfoPage extends StatelessWidget{

  final ProfModel prof;
  ProfInfoPage({this.prof});

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(prof.firstname+" "+prof.lastname),
      ),
      body: Column(children: <Widget>[
        Center(
            child: Image.network(
              prof.urlPhoto,
            )
        ), Center(child: Text("Bureau : "+prof.office),),
        Center(child: Text("Téléphone : "+prof.phone),),
      ],)
    );
  }
}

