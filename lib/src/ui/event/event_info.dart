//When user click on an event
import 'package:bde_esiee_mobile/src/blocs/clubs_bloc.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventInfoPage extends StatefulWidget {

  EventModel event;
  EventInfoPage({this.event});

  @override
  State<StatefulWidget> createState() {
    return EventInfoState();

  }
}

class EventInfoState extends State<EventInfoPage> {

  final bloc = ClubsBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchClubById(widget.event.idClubRef);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(

        ),
        body: StreamBuilder(
            stream: bloc.thisClub,
            builder: (context, AsyncSnapshot<ClubModel> snapshot) {
              if (snapshot.hasData) {
                return
                  ListView(
                        children : [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(widget.event.backgroundUrl)
                                ),
                                color: Colors.white,
                              )),
                          ListTile(
                          title: Text(widget.event.name.toUpperCase(), textAlign: TextAlign.center),
                          ),
                          getDate(),
                          ListTile(
                          leading: Icon(Icons.business_center, color: Colors.green, size: 30.0,),
                          title: Text(snapshot.data.name),
                          ),
                          ListTile(
                          leading: Icon(Icons.place,color: Colors.green, size: 30.0,),
                          title: Text(widget.event.place)

                        ),
                        ListTile(
                          leading: Icon(Icons.monetization_on,color: Colors.green, size: 30.0,),
                          title: Text(widget.event.link),
                        ),
                          ListTile(
                            leading: Icon(Icons.euro_symbol, color: Colors.green, size:30.0,),
                            title:Text(widget.event.price.toString() + ' €'),
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.facebookSquare, color: Colors.green, size:30.0,),
                          ),
                          ListTile(
                            leading: Icon(Icons.textsms,color: Colors.green, size: 30.0,),
                            title: Text(widget.event.description.replaceAll(RegExp('<[^>]*>'), "")),
                          )
              ]);
              }




               else if (snapshot.hasError) {
              return ListTile(
              leading: Icon(Icons.check_circle,color: Colors.green, size: 30.0,),
              title: Text('CLUB organisateur inconnu'),
              );
              }
              return Center(child: CircularProgressIndicator());
            }),floatingActionButton: FloatingActionButton(
      onPressed: () {
      },
      child: Icon(Icons.calendar_today, color: Colors.white),
      backgroundColor: Colors.blue,
    ));



  }

  ListTile getDate()
  {
    if( formatDate(widget.event.endDate) == formatDate(widget.event.startDate))
    {
      return ListTile(
        leading: Icon(Icons.calendar_today,color: Colors.green, size: 30.0,),
        title: Text('Le ' + formatDate(widget.event.startDate)),
      );
    }
    else {
        return ListTile(
          leading: Icon(Icons.calendar_today,color: Colors.green, size: 30.0,),
          title: Text('Du ' + formatDate(widget.event.startDate)),
          subtitle: Text('Au ' + formatDate(widget.event.endDate)),
        );
    }
  }

  String formatDate(DateTime date)
  {
    return DateFormat('dd MMMM').format(date);
  }


}