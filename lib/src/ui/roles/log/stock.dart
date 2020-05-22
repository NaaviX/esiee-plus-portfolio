import 'package:bde_esiee_mobile/src/App.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Stock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StockState();
  }
}

class StockState extends State<Stock> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(FontAwesomeIcons.shoppingCart,),
                    text: "Tac",
                  ),
                  Tab(
                      icon: Icon(FontAwesomeIcons.cocktail),
                      text: "Reserve"
                  ),
                ],
              ),
              title: Text("Stock"),
            ),
            body: TabBarView(
              children: [
                Tac(),
                Reserve(),
              ],
            )
        ));
  }
}

class Tac extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TacState();
  }
}

class TacState extends State<Tac> {

  @override
  void initState() {}

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Reserve extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReserveState();
  }
}

class ReserveState extends State<Reserve> {

  @override
  void initState() {}

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
