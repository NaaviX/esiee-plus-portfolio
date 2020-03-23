import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {

  @required BuildContext context;
  @required EventModel event;

  EventCard(this.event, this.context);

  @override
  Widget build(BuildContext context) {
    return Padding(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Theme
              .of(context)
              .primaryColor,
          child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  child: Center(
                    child: Text(getTitle(event), style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0), textAlign: TextAlign.center,),
                  ),
                ),
                Stack(children: <Widget>[
                  Container(
                    height: 150,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: _filter(),
                        image: new NetworkImage(
                          event.backgroundUrl,
                        ),
                      ),
                    ),
                  ),
                  _isEnded(context),
                ]),
              ]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
        ),
        padding: EdgeInsets.only(top: 10.0,left: 15.0, right: 15.0)
    );
  }

  String getTitle(EventModel event){
    String result = event.name;
    if (event.startDate != null)
      result += '  -  ' + DateFormat('dd MMM').format(event.startDate) + '.';
    return result;
  }

  _isEnded(context) {
    if (!(event.endDate != null && event.endDate.isAfter(DateTime.now())))
      return Container(
          height: 150,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Center(child: Text(("terminé").toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 30.0))),
          margin: EdgeInsets.only(
              bottom: 0.0, left: 15.0, right: 15.0)
      );
    else return Container();
  }

  _filter() {
    if (!(event.endDate != null && event.endDate.isAfter(DateTime.now()))) return new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstOut);
    else return null;
  }
}