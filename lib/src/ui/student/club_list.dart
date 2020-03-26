import 'package:auto_size_text/auto_size_text.dart';
import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../../App.dart';
import '../../blocs/clubs_bloc.dart';

class ClubList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClubListState();
  }
}

class ClubListState extends State<ClubList> {
  final bloc = ClubsBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchAllClubs();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  final log = Logger('clubList');

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Les clubs"),
        ),
        body: StreamBuilder(
          stream: bloc.allClubs,
          builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
            if (snapshot.hasData) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }

  Widget buildList(AsyncSnapshot<List<ClubModel>> snapshot) {

    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          if(snapshot.data[index].idClubRef <= 100) {
            return ListTile(
              leading:
              GestureDetector(
                child: Hero(
                  tag: 'logoClub'+snapshot.data[index].idClubRef.toString(),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data[index].urlPhoto),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              title: Text(snapshot.data[index].name),
              trailing: snapshot.data[index].students.contains(Base.thisUser) ? Icon(Icons.verified_user, color: Colors.green) : Column(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClubInfoPage(club : snapshot.data[index])),
                );
              },
            );
          }
          else return null;
        });
  }

  String formatDate(DateTime date){
    return new DateFormat('yyyy MMMM dd').format(date);
  }



}

//When user click on a club
class ClubInfoPage extends StatelessWidget{

  final ClubModel club;
  ClubInfoPage({this.club});

  @override Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(club.name),
        ),
        body: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                color: Colors.white10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/58373256_2184091388372532_6829136169737912320_o.png?_nc_cat=105&_nc_sid=dd9801&_nc_ohc=hLHSh8tWyykAX98Tkj9&_nc_ht=scontent-cdt1-1.xx&oh=3b211fd411430d2df6fbf0e16b40467b&oe=5EA2D979")
                  ),
                  color: Colors.transparent,
                ),
              ),
              Container(
                height: 400,
                child: Card(
                  margin: EdgeInsets.fromLTRB(30, 150, 30, 20),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 110),
                    child: Column(
                        children: <Widget>[
                          AutoSizeText(club.name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,), maxLines: 1,),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      AutoSizeText("Membres", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                      AutoSizeText("27", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
                                    ]
                                ),
                                Container(height: 50, child: VerticalDivider(color: Colors.black, width: 2,)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      AutoSizeText("Evénements", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                      AutoSizeText("27", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
                                    ]
                                ),
                                Container(height: 50, child: VerticalDivider(color: Colors.black, width: 2,)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      AutoSizeText("Classement", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                                      AutoSizeText("3", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
                                    ]
                                ),
                              ],
                            ),
                          )
                        ]
                    ),
                  ),
                ),
              ),
              Positioned(
                top:50 ,
                child: GestureDetector(
                  child: Hero(
                    tag: 'logoClub'+club.idClubRef.toString(),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(club.urlPhoto),
                      backgroundColor: Colors.white,
                      radius:100,
                    ),
                  ),
                ),
              ),
            ]
        )
    );

    /*GestureDetector(
              child: Hero(
                tag: 'logoClub'+club.idClubRef.toString(),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(club.urlPhoto),
                  backgroundColor: Colors.transparent,
                  radius:100,
                ),
              ),
            ),
          ),
        ],
      ),*/

    /*Column(
      children: <Widget> [
      Container(
          width: MediaQuery.of(context).size.width,
          height: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("https://bde.esiee.fr/bundles/applicationbde/img/couverture.png")
            ),
            color: Colors.white,
          ),
      ),
    Container(
      margin: EdgeInsets.only(top: -50),
      child: GestureDetector(
        child: Hero(
          tag: 'logoClub'+club.idClubRef.toString(),
          child: CircleAvatar(
            backgroundImage: NetworkImage(club.urlPhoto),
            backgroundColor: Colors.white,
            radius: 100,
          ),
        ),
      ),
    ),
        ]
      )
    );*/
  }
}

