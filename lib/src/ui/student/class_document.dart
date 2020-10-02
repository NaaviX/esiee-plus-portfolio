import 'package:flutter/material.dart';

class ClassDocument extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClassDocumentState();
  }
}
class ClassDocumentState extends State<ClassDocument> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cours"),
        ),
        body:Column(
            children: <Widget>[
              Image(image: AssetImage('assets/illustration/cours.webp'),width: MediaQuery.of(context).size.width,),
            ]
        )
    );
  }


}