import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnnalsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnnalsListState();
  }
}

class AnnalsListState extends State<AnnalsList> {

  File _image;
  String _uploadedFileURL;

  @override Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Firestore File Upload'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Selected Image'),
              _image != null
                  ? Image.asset(
                _image.path,
                height: 150,
              )
                  : Container(height: 150),
              _image == null
                  ? RaisedButton(
                child: Text('Choose File'),
                onPressed: chooseFile,
                color: Colors.cyan,
              )
                  : Container(),
              _image != null
                  ? RaisedButton(
                child: Text('Upload File'),
                onPressed: uploadFile,
                color: Colors.cyan,
              )
                  : Container(),
            ],
          ),
        ),
      );  ;
  }

  Future chooseFile() async {
    await FilePicker.getFile(type: FileType.any).then((file) {
      setState(() {
        _image = file;
      });
    });
  }

  add() {
    Firestore.instance.collection('Message')
        .document('message'+DateTime.now().microsecondsSinceEpoch.toString())
        .setData(
        { 'type':'msg',
          'subject':'sub',
          'description':'description',
          'to':'user1',
          'from':'uid',
        });
  }
}