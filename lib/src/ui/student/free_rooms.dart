import 'package:flutter/material.dart';

class FreeRooms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Salles libres"),
        ),
        body: Column(
            children: <Widget>[
              Image(image: AssetImage('assets/freeRooms.png'),width: MediaQuery.of(context).size.width,),
            ]
        )
    );
  }
}