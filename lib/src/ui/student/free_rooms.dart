import 'package:bde_esiee_mobile/src/blocs/free_rooms_bloc.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class FreeRooms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FreeRoomsState();
  }
}

class FreeRoomsState extends State<FreeRooms> {
  final bloc = FreeRoomsBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchAllRooms();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  final log = Logger('freeRoomsList');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Salles Libres"),
        ),
        body: StreamBuilder(
          stream: bloc.allRoomsLog,
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height,
                child: buildList(context, snapshot)
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  buildList(context, AsyncSnapshot<List<dynamic>> snapshot) {

    List<String> epi0 = List<String>();
    List<String> epi1 = List<String>();
    List<String> epi2 = List<String>();
    List<String> epi3 = List<String>();
    List<String> epi4 = List<String>();
    List<String> epi5 = List<String>();

    snapshot.data.forEach((element) {
      element.substring(0,1)=="0" ? epi0.add(element) :
      element.substring(0,1)=="1" ? epi1.add(element) :
      element.substring(0,1)=="2" ? epi2.add(element) :
      element.substring(0,1)=="3" ? epi3.add(element) :
      element.substring(0,1)=="4" ? epi4.add(element) :
      epi5.add(element);
    });

    return Column(
      children: <Widget>[
        Image(image: AssetImage('assets/freeRooms.png'),width: MediaQuery.of(context).size.width, height: 200,),
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
                Text("EPI", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: SecondaryColor),),
                Text(i.toString(), style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: SecondaryColor),),
              ],
            ),
          ),
          Expanded(
            child: Text(epi.substring(1,epi.length-1), style: TextStyle(fontSize: 15, color: PrimaryColor),),
          ),
        ],
      ),
    );
  }
}