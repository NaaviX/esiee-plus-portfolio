import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Stock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StockState();
  }
}

class StockState extends State<Stock>
    with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
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
            controller: _tabController,
            children: [
              Tac(),
              Reserve(),
            ],
          ),
          floatingActionButton: _bottomButtons(),
        ));
  }

  Widget _bottomButtons() {
    return FloatingActionButton(
        //shape: StadiumBorder(),
        onPressed: _tabController.index == 0
            ? null
            : null,
        backgroundColor: PrimaryColor,
        child: Icon(
          Icons.add,
          size: 20.0,
        )
    );
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
