import 'package:bde_esiee_mobile/src/blocs/profs_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_event.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_state.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/ui/prof/prof_list.dart';
import 'package:bde_esiee_mobile/src/ui/prof/search_prof.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'package:meta/meta.dart';

class UnitsList extends StatefulWidget {
  final ProfsBloc profsBloc;

  UnitsList({Key key, @required this.profsBloc})
      : assert(profsBloc != null),
        super(key: key);


  @override
  State<StatefulWidget> createState() {
    return UnitsListState();
  }
}

class UnitsListState extends State<UnitsList> {
  FocusNode currentFocus;

  @override
  void initState() {
    BlocProvider.of<UnitsBloc>(context).add(UnitsRequested());
    super.initState();
  }

  final log = Logger('UnitsList');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Les Matières"),
        ),
        body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Wrap(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      currentFocus = FocusScope.of(context);
                      currentFocus.unfocus();
                    },
                    child: Container(
                        margin: EdgeInsets.all(5),
                        child: BlocProvider(
                            create: (BuildContext context) => widget.profsBloc,
                            child: SearchProf(this))
                    )
                ),
                Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 170,
                    child: BlocBuilder<UnitsBloc, UnitState>(
                        builder: (context, state) {
                          if (state is UnitsInitial) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is UnitsLoadInProgress) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is UnitsLoadSuccess) {
                            final units = state.units;
                            return ListView.builder(
                                padding: EdgeInsets.only(
                                    bottom: 20, right: 10, left: 10),
                                itemCount: units.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: new InkWell(
                                      onTap: () =>
                                      {Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return BlocProvider(create: (
                                              BuildContext context) =>
                                          widget.profsBloc,
                                              child: ProfList(
                                                selectedUnit: units[index],));
                                        }),
                                      )},
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: new Container(
                                          padding: new EdgeInsets.all(20.0),
                                          child: Text(
                                            units[index].unitName
                                                .toUpperCase(),
                                            style: TextStyle(color: Theme
                                                .of(context)
                                                .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),)),
                                    ),
                                  );
                                }
                            );
                          }
                          if (state is UnitsLoadFailure) {
                            return Text(
                              'Something went wrong!',
                              style: TextStyle(color: Colors.red),
                            );
                          }
                          return Container();
                        })
                )
              ],
            )
        )
    );
  }

  getTextWidgets(AsyncSnapshot<List<UnitModel>> snapshot) {
    List<Widget> list = new List<Widget>();
    snapshot.data.forEach((element) {
      list.add(
          new Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 5,
                //color: Colors.blue.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: new InkWell(
                  onTap: () => {},
                  borderRadius: BorderRadius.circular(10.0),
                  child: new Container(
                      padding: new EdgeInsets.all(25.0),
                      child: Text(element.unitName.toUpperCase(),
                        style: TextStyle(color: Theme
                            .of(context)
                            .primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),)),
                ),
              )
          )
      );
    });
    return list;
  }
}