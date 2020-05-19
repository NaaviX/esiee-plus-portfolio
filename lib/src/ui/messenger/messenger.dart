import 'dart:io';

import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../App.dart';

class Messenger extends StatefulWidget {
  final StudentModel student;
  final ClubModel club;
  final ProfModel prof;

  Messenger({Key key, this.club, this.prof, this.student}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MessengerState();
  }
}

class MessengerState extends State<Messenger> {
  List<DocumentSnapshot> listMessage;
  File imageFile;
  bool isLoading;
  String imageUrl;

  String groupChatId;

  final ScrollController listScrollController = new ScrollController();
  final TextEditingController textEditingController = new TextEditingController();
  final FocusNode focusNode = new FocusNode();

  String from;
  String to;
  String nameTo = "";

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    imageUrl = '';

    print("eleve:"+widget.student.toString());
    print("prof:"+widget.prof.toString());
    print("club:"+widget.club.toString());
    from = user.email;
    if (widget.student != null) {
      to = widget.student.mailEsiee;
      nameTo = widget.student.firstname + " " + widget.student.lastname;
    } else if (widget.prof != null) {
      to = widget.prof.mailEsiee;
      nameTo = widget.prof.firstname + " " + widget.prof.lastname;
    } else if (widget.club != null) {
      to = widget.club.mail;
      nameTo = widget.club.name;
    }

    readLocal();
  }

  readLocal() async {
    String email = user.email;
    if (from.hashCode <= to.hashCode) {
      groupChatId = '$from::$to';
    } else {
      groupChatId = '$to::$from';
    }
    setState(() {});
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {});
    }
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, "image");
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      //This file is not an image;
    });
  }

  void onSendMessage(String content, String type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          Firestore.instance
              .collection('messages')
              .document(groupChatId),
          {
            'actif': true,
          },
        );
      });

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'from': from,
            'to': to,
            'timestamp': DateTime
                .now()
                .millisecondsSinceEpoch
                .toString(),
            'content': content,
            'type': type,
            'hasBeenRead': false
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      //Nothing to send
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['from'] == from) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['from'] != from) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool needTime(int index) {
    String t;
    String t_pres;

    if(index>0) {
      t = DateFormat('dd MMM kk:mm').format(
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(listMessage[index]['timestamp'])));
      t_pres = DateFormat('dd MMM kk:mm').format(
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(listMessage[index - 1]['timestamp'])));
    }

    if ((index > 0 &&
        listMessage != null && t != t_pres) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(nameTo),
        ),
        body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),

                  // Input content
                  buildInput(),
                  SizedBox(height: 10,)
                ],
              ),

              // Loading
              buildLoading()
            ],
          ),
          onWillPop: onBackPress,
        ));
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(PrimaryColor)),
        ),
      )
          : Container(),
    );
  }

  Widget buildInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Button send image
        Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: PrimaryColor,
              ),
            ),
            color: Colors.transparent
        ),

        // Edit text
        Flexible(
          child: TextField(
            style: TextStyle(color: PrimaryColor, fontSize: 15.0),
            controller: textEditingController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 6,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blueGrey.withOpacity(0.1),
              hintText: 'Ton message...',
              hintStyle: TextStyle(color: Colors.grey,),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25.7),
              ),
            ),
            focusNode: focusNode,
          ),
        ),

        // Button send message
        Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () =>
                    onSendMessage(textEditingController.text, "texte"),
                color: PrimaryColor,
              ),
            ),
            color: Colors.transparent
        ),
      ],
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
          child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(PrimaryColor)))
          : StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .limit(100)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        PrimaryColor)));
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                if(listMessage[index]["from"] != user.email) {
                  Firestore.instance.runTransaction((transaction) async {
                    await transaction.update(

                      listMessage[index].reference,
                      {
                        'hasBeenRead': true
                      },
                    );
                  });
                }
                return buildItem(index, listMessage[index]);
              },
              itemCount: listMessage.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  /*Widget buildItem(int index, DocumentSnapshot document) {
    if (document['from'] == from) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == "texte"
          // Text
              ? Container(
            child: Text(
              document['content'],
              style: TextStyle(color: PrimaryColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
              : document['type'] == "image"
          // Image
              ? Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              PrimaryColor),
                        ),
                        width: 200.0,
                        height: 200.0,
                        padding: EdgeInsets.all(70.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      ),
                  errorWidget: (context, url, error) =>
                      Material(
                        child: Image.asset(
                          'images/img_not_available.jpeg',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
//                Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
          // Sticker
              : Container(
            child: new Image.asset(
              'images/${document['content']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
//                isLastMessageLeft(index)
//                    ? Material(
//                  child: CachedNetworkImage(
//                    placeholder: (context, url) => Container(
//                      child: CircularProgressIndicator(
//                        strokeWidth: 1.0,
//                        valueColor: AlwaysStoppedAnimation<Color>(AppState.primaryColor),
//                      ),
//                      width: 35.0,
//                      height: 35.0,
//                      padding: EdgeInsets.all(10.0),
//                    ),
//                    //imageUrl: peerAvatar,
//                    width: 35.0,
//                    height: 35.0,
//                    fit: BoxFit.cover,
//                  ),
//                  borderRadius: BorderRadius.all(
//                    Radius.circular(18.0),
//                  ),
//                  clipBehavior: Clip.hardEdge,
//                )
                document['type'] == "texte"
                    ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : document['type'] == "image"
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    PrimaryColor),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                        errorWidget: (context, url, error) =>
                            Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(
                  child: new Image.asset(
                    'images/${document['content']}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document['timestamp']))),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }*/

  Widget buildItem(int index, DocumentSnapshot document) {
    return Container(
      width: MediaQuery.of(context).size.width-100,
      child: document['from'] == from ?
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
        msg(index, document, "sender"),
        time(index, document),
      ],) :
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        msg(index, document, "receiver"),
        time(index, document),
      ],),
    );
  }

  time(int index, DocumentSnapshot document) {
    return needTime(index) ?
    Container(
      child: Text(
        DateFormat('dd MMM kk:mm', 'FR_fr').format(
            DateTime.fromMillisecondsSinceEpoch(
                int.parse(document['timestamp']))),
        style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
            fontStyle: FontStyle.italic),
      ),
      margin: EdgeInsets.only(left: 0, bottom: 5.0),
    )
        : Container();
  }

  msg(int index, DocumentSnapshot document, String type) {
    return Row(
        mainAxisAlignment: type=="sender" ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          document['type'] == "texte" ?
          Container(
            child: Text(
              document['content'],
              style: type=="sender" ? TextStyle(color: Colors.white, fontSize: 15) : TextStyle(color: Colors.white, fontSize: 15),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            decoration: BoxDecoration(
                color: type=="sender" ? PrimaryColor.withOpacity(0.5) : Colors.blueGrey.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: type=="sender" ? Radius.circular(5) : Radius.circular(20),
                  bottomLeft: type=="sender" ? Radius.circular(20) : Radius.circular(5),)
            ),
            margin: EdgeInsets.only(bottom: 2),
          )
              : document['type'] == "image"
              ? Container(child: FlatButton(
            child: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) =>
                    Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            PrimaryColor),
                      ),
                      width: 200.0,
                      height: 200.0,
                      padding: EdgeInsets.all(70.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                errorWidget: (context, url, error) =>
                    Material(
                      child: Image.asset(
                        'images/img_not_available.jpeg',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                imageUrl: document['content'],
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              borderRadius:
              BorderRadius.all(Radius.circular(8.0)),
              clipBehavior: Clip.hardEdge,
            ),
            onPressed: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
            },
            padding: EdgeInsets.all(0),
          ),
            margin: EdgeInsets.only(left: 10.0),
          )
              : Container(
            child: new Image.asset(
              'images/${document['content']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          ),
        ]
    );


    /*if (document['from'] == from) {
              : document['type'] == "image"
          // Image
              ? Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              PrimaryColor),
                        ),
                        width: 200.0,
                        height: 200.0,
                        padding: EdgeInsets.all(70.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      ),
                  errorWidget: (context, url, error) =>
                      Material(
                        child: Image.asset(
                          'images/img_not_available.jpeg',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
//                Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
          // Sticker
              : Container(
            child: new Image.asset(
              'images/${document['content']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }*/
    /*else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
                    : document['type'] == "image"
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    PrimaryColor),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                        errorWidget: (context, url, error) =>
                            Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(
                  child: new Image.asset(
                    'images/${document['content']}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                ),
              ],
            ),
            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document['timestamp']))),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }*/
  }
}
