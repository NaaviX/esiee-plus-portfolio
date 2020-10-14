import 'package:bde_esiee_mobile/src/blocs/free_rooms_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/free_rooms_event.dart';
import 'package:bde_esiee_mobile/src/blocs/free_rooms_state.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class FreeRooms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FreeRoomsState();
  }
}

class FreeRoomsState extends State<FreeRooms> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FreeRoomsBloc>(context).add(FreeRoomsRequested());
  }

  final log = Logger('freeRoomsList');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Salles Libres"),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                padding: EdgeInsets.all(5),
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 6),
                        content: Text("Les salles indiquées ne sont pas occupées par un cours en ce moment, elles peuvent cependant ne pas être disponibles.", textAlign: TextAlign.justify,
                            style: TextStyle(color: MyTheme.ColorTheme(context, colorLight: Colors.black, colorDark: Colors.white))),
                        backgroundColor: Colors.blueAccent,
                      )
                  );
                },
              ),
            ]
        ),
        body: BlocBuilder<FreeRoomsBloc, FreeRoomState>(builder: (context, state) {
          if (state is FreeRoomsInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is FreeRoomsLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is FreeRoomsLoadSuccess) {
            final freeRooms = state.freeRooms;

            return Container(
                margin: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height,
                child: buildList(context, freeRooms)
            );
          }
          if (state is FreeRoomsLoadFailure) {
            return Center(child: CircularProgressIndicator());
          }
          return Container();
        })
    );
  }

  buildList(context, List<dynamic> freeRooms) {

    List<String> epi0 = List<String>();
    List<String> epi1 = List<String>();
    List<String> epi2 = List<String>();
    List<String> epi3 = List<String>();
    List<String> epi4 = List<String>();
    List<String> epi5 = List<String>();

    freeRooms.forEach((element) {
      element.substring(0,1)=="0" ? epi0.add(element) :
      element.substring(0,1)=="1" ? epi1.add(element) :
      element.substring(0,1)=="2" ? epi2.add(element) :
      element.substring(0,1)=="3" ? epi3.add(element) :
      element.substring(0,1)=="4" ? epi4.add(element) :
      epi5.add(element);
    });

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image(image: AssetImage('assets/illustration/freeRooms.webp'), height: MediaQuery.of(context).size.height/6,),
          epi(0, epi0.toString()),
          Divider(height: 1, thickness: 1,),
          epi(1, epi1.toString()),
          Divider(height: 1, thickness: 1,),
          epi(2, epi2.toString()),
          Divider(height: 1, thickness: 1,),
          epi(3, epi3.toString()),
          Divider(height: 1, thickness: 1,),
          epi(4, epi4.toString()),
          Divider(height: 1, thickness: 1,),
          epi(5, epi5.toString()),
        ],
      ),
    );
  }

  epi(int i, String epi) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("EPI", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),),
                Text(i.toString(), style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),),
              ],
            ),
          ),
          Expanded(
            child: Text(epi.substring(1,epi.length-1), style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor),),
          ),
        ],
      ),
    );
  }
}