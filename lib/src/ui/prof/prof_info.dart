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
            //color: PrimaryColor,
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
      color: PrimaryColor.withOpacity(0.8),
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height/3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          prof.urlPhoto == null || prof.urlPhoto == "null" ?
          CircleAvatar(
            radius: 50,
            backgroundColor: PrimaryColor,
            child: Icon(Icons.person, color: Colors.white, size: 50,),
          ) :
          CircleAvatar(
            backgroundImage: NetworkImage(prof.urlPhoto),
            backgroundColor: Colors.white,
            radius:50,
          ),
          SizedBox(height: 10,),
          Text(prof.firstname + " " + prof.lastname, style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,)),
          Text(prof.units.toString()),
        ],
      ),
    );
  }
}