import 'package:bde_esiee_mobile/src/blocs/unit_bloc.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_list.dart';
import 'package:bde_esiee_mobile/src/ui/prof/search_prof.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class UnitsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UnitsListState();
  }
}

class UnitsListState extends State<UnitsList> {
  UnitBloc units = UnitBloc();

  FocusNode currentFocus;

  @override
  void initState() {
    units.fetchAllUnits();
    super.initState();
  }

  @override
  void dispose() {
    units.dispose();
    super.dispose();
  }

  final log = Logger('UnitsList');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Les Matières"),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
              stream: units.allUnits,
              builder: (context, AsyncSnapshot<List<UnitModel>> snapshot) {
                if (snapshot.hasData) {
                  return Wrap (
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            currentFocus = FocusScope.of(context);
                            currentFocus.unfocus();
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: SearchProf(this),
                          )
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 170,
                        child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: new InkWell(
                                  onTap: () => {Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProfList(selectedUnit: snapshot.data[index],)),
                                  )},
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: new Container(
                                      padding: new EdgeInsets.all(24.0),
                                      child:Text(snapshot.data[index].unitName.toUpperCase(),
                                        style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),)),
                                ),
                              );
                            }
                        ),
                      )
                      /*ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: new InkWell(
                                onTap: ()=> {},
                                borderRadius: BorderRadius.circular(10.0),
                                child: new Container(
                                    padding: new EdgeInsets.all(25.0),
                                    child:Text(snapshot.data[index].unitName.toUpperCase(),
                                      style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),)),
                              ),
                            );
                          }
                      )*/
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            )
        )
    );
  }

  getTextWidgets(AsyncSnapshot<List<UnitModel>> snapshot) {
    List<Widget> list = new List<Widget>();
    snapshot.data.forEach((element) {list.add(
        new Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              elevation: 5,
              //color: Colors.blue.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: new InkWell(
                onTap: ()=> {},
                borderRadius: BorderRadius.circular(10.0),
                child: new Container(
                    padding: new EdgeInsets.all(25.0),
                    child:Text(element.unitName.toUpperCase(),
                      style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),)),
              ),
            )
        )
    );});
    return list;
  }
}