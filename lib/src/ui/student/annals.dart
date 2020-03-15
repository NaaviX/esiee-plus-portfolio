import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

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

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('annals/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  /*Future listFiles() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('annals/${Path.basename(_image.path)}').listAll();
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }*/
}