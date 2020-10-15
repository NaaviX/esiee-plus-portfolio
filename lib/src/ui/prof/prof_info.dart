import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/material.dart';

class ProfInfoPage extends StatelessWidget{

  final ProfModel prof;
  ProfInfoPage({this.prof});

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(prof.firstname+" "+prof.lastname),
        ),
        body: Column(children: <Widget>[
          _header(context),
          SizedBox(height: 20,),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.all(10),
            //color: Theme.of(context).primaryColor,
            child: Container(
              //height: 300,
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.mail_outline),
                      title: Text("Mail", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(prof.mailEsiee),
                    ),
                    prof.phone != "" ?
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text("Téléphone", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(prof.phone),
                    ) : Container(),
                    prof.office != "" ?
                    ListTile(
                      leading: Icon(Icons.place),
                      title: Text("Bureau", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(prof.office),
                    ) : Container(),
                  ]
              ),
            ),
          )
        ],)
    );
  }
  _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/50),
      color: Theme.of(context).primaryColor.withOpacity(0.5),
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          prof.urlPhoto == null || prof.urlPhoto == "null" ?
          CircleAvatar(
            radius: MediaQuery.of(context).size.height/15,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.person, size: MediaQuery.of(context).size.height/15,),
          ) :
          CircleAvatar(
            backgroundImage: NetworkImage(prof.urlPhoto),
            backgroundColor: Colors.white,
            radius:50,
          ),
          SizedBox(height: 10,),
          Text(prof.firstname + " " + prof.lastname, style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,)),
          SizedBox(height: 10,),
          prof.units.isNotEmpty ?
          Wrap(
            spacing: 10,
            children: _listProfUnits(context),
          ) : Container(),
          //Text(prof.units.toString()),
        ],
      ),
    );
  }

  List<Widget> _listProfUnits(context) {
    List<Widget> list = List<Widget>();
    prof.units.forEach((element) {list.add(
      Chip(
        label: Text(element.unitCode, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color : Colors.white)),
        backgroundColor: MyTheme.colorTheme(context, colorDark: MyTheme.DarkBackground),
      )
    );});
    return list;
  }
}