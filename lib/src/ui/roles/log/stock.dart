import 'package:bde_esiee_mobile/src/blocs/stock_bloc.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/ui/roles/log/stock_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Stock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StockState();
  }
}

class StockState extends State<Stock> with SingleTickerProviderStateMixin{

  TabController _tabController;
  StockBloc stocks = StockBloc();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    stocks.fetchAllStocks();
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      stocks.fetchAllStocks();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    stocks.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
      stocks.fetchAllStocks();
    });
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
            body: Container(
              child: StreamBuilder(
                  stream: stocks.allStocks,
                  builder: (context, AsyncSnapshot<List<StockModel>> snapshot) {
                    if (snapshot.hasData) {
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          Tac(context, stocks, snapshot),
                          Reserve(context, stocks, snapshot),
                        ],
                      );
                    }
                    else return Center(child: CircularProgressIndicator());
                  }),
            ),
            floatingActionButton: _bottomButtons()
        )
    );
  }

  Widget _bottomButtons() {
    return FloatingActionButton(
      //shape: StadiumBorder(),
        onPressed: () => showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AddStock(this);
            }
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add_shopping_cart,
          size: 20.0,
        )
    );
  }
}

class Tac extends StatefulWidget {

  StockBloc stocks;
  AsyncSnapshot<List<StockModel>> snapshot;
  Tac(context, this.stocks, this.snapshot);

  @override
  State<StatefulWidget> createState() {
    return TacState();
  }
}

class TacState extends State<Tac> {

  @override
  Widget build(BuildContext context) {
    /*return Container(
        child: StreamBuilder(
            stream: widget.stocks.allStocks,
            builder: (context, AsyncSnapshot<List<StockModel>> snapshot) {
              if (snapshot.hasData) {*/
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text("Cannettes", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
                      Column(
                        children: _List(context, widget.snapshot, widget.stocks, "Cannette"),
                      ),
                      SizedBox(height: 20,),
                      Text("Snacks", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
                      Column(
                        children: _List(context, widget.snapshot, widget.stocks, "Snack"),
                      ),
                      SizedBox(height: 20,),
                      Text("Autres", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
                      Text("DLC = Date Limite de Consomation", style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.8), fontSize: 15),),
                      SizedBox(height: 5,),
                      Column(
                        children: _List(context, widget.snapshot, widget.stocks, "Autre"),
                      ),
                    ],
                  ),
                );
              /*}
              else return Center(child: CircularProgressIndicator());
            })
    );*/
  }

  _hard(context, AsyncSnapshot<List<StockModel>> snapshot, StockBloc stocks) {
    return Column(
        children: [
          Text("Hard Pack", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
          Column(
            children: _List(context, snapshot, stocks, "Hard Pack"),
          ),
          SizedBox(height: 20,),
          Text("Hard", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
          Column(
            children: _List(context, snapshot, stocks, "Hard"),
          ),
        ]
    );
  }

  _soft(context, AsyncSnapshot<List<StockModel>> snapshot, StockBloc stocks) {
    return Column(
        children: [
          Text("Soft Pack", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
          Column(
            children: _List(context, snapshot, stocks, "Soft Pack"),
          ),
          SizedBox(height: 20,),
          Text("Soft", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
          Column(
            children: _List(context, snapshot, stocks, "Soft"),
          ),
        ]
    );
  }

  _List(context, AsyncSnapshot<List<StockModel>> snapshot, StockBloc stocks, String type) {
    List<Widget> list = List<Widget>();
    List<StockModel> listOfType = List<StockModel>();

    snapshot.data.forEach((element) { if(element.stockType == type) listOfType.add(element); });

    listOfType.isNotEmpty ?
    listOfType.forEach((type) {
      int quantity = type.stockQuant.toInt();

      String info = type.stockType == "Cannette" ? "nombre de pallette(s)"
          : type.stockType == "Snack" ? "nombre de boite(s)"
          : type.stockType == "Autre" ? "DLC : " + DateFormat('dd-MM-yyyy', "fr FR").format(type.date)
          : type.stockType == "Hard" ? "bouteille(s) de " + type.bottleQuant.toString()
          : type.stockType == "Hard Pack" ? "nombre de pack(s)"
          : type.stockType == "Soft" ? "nombre de bouteille(s)"
          : type.stockType == "Soft Pack" ? "nombre de pack(s)"
          : "";

      list.add(
        Card(
            margin: EdgeInsets.all(5),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(type.stockName, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(info, style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.8), fontSize: 15),),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          if(quantity != 0) {
                            quantity -= 1;
                            type.stockQuant -= 1;
                            stocks.addSaveStock(type);
                            setState(() {});
                          }
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.remove,
                        ),
                        shape: CircleBorder(),
                      ),
                      Text(quantity.toString(), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                      RawMaterialButton(
                        onPressed: () {
                          quantity += 1;
                          type.stockQuant += 1;
                          stocks.addSaveStock(type);
                          setState(() {});
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.add,
                        ),
                        shape: CircleBorder(),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      );
    }) : Container();

    if(listOfType.isNotEmpty) return list;
    else return [Text("Aucun élément de type " + type.toLowerCase() + " en reserve")];
  }
}

class Reserve extends StatefulWidget {

  StockBloc stocks;
  AsyncSnapshot<List<StockModel>> snapshot;
  Reserve(context, this.stocks, this.snapshot);

  @override
  State<StatefulWidget> createState() {
    return ReserveState();
  }
}

class ReserveState extends State<Reserve> {

  String selected = "Soft";
  List<String> list = ["Soft", "Hard"];

  @override
  Widget build(BuildContext context) {
    /*return Container(
        child: StreamBuilder(
            stream: widget.stocks.allStocks,
            builder: (context, AsyncSnapshot<List<StockModel>> snapshot) {
              if (snapshot.hasData) {*/
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButton<String>(
                        isExpanded: true,
                        underline: Column(),
                        value: selected,
                        onChanged: (String newValue) {
                          setState(() {
                            selected = newValue;
                          });
                        },
                        items: list.map<DropdownMenuItem<String>>((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(
                                role,
                                style: TextStyle(
                                    color: role == selected ? Colors.black : Colors
                                        .black54,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10,),
                      selected == "Hard" ? _hard(context, widget.snapshot, widget.stocks) : Container(),
                      selected == "Soft" ? _soft(context, widget.snapshot, widget.stocks) : Container(),
                    ],
                  ),
                );
              /*}
              else return Container();
            })
    );*/
  }

  _hard(context, AsyncSnapshot<List<StockModel>> snapshot, StockBloc stocks) {
    return Column(
        children: [
          Text("Hard Pack", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
          Column(
            children: _List(context, snapshot, stocks, "Hard Pack"),
          ),
          SizedBox(height: 20,),
          Text("Hard", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
          Column(
            children: _List(context, snapshot, stocks, "Hard"),
          ),
        ]
    );
  }

  _soft(context, AsyncSnapshot<List<StockModel>> snapshot, StockBloc stocks) {
    return Column(
        children: [
          Text("Soft Pack", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
          Column(
            children: _List(context, snapshot, stocks, "Soft Pack"),
          ),
          SizedBox(height: 20,),
          Text("Soft", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
          Column(
            children: _List(context, snapshot, stocks, "Soft"),
          ),
        ]
    );
  }

  _List(context, AsyncSnapshot<List<StockModel>> snapshot, StockBloc stocks, String type) {
    List<Widget> list = List<Widget>();
    List<StockModel> listOfType = List<StockModel>();

    snapshot.data.forEach((element) { if(element.stockType == type) listOfType.add(element); });

    listOfType.isNotEmpty ?
    listOfType.forEach((type) {
      int quantity = type.stockQuant.toInt();

      String info = type.stockType == "Cannette" ? "nombre de pallette(s)"
          : type.stockType == "Snack" ? "nombre de boite(s)"
          : type.stockType == "Autre" ? "DLC : " + DateFormat('dd-MM-yyyy', "fr FR").format(type.date)
          : type.stockType == "Hard" ? "bouteille(s) de " + type.bottleQuant.toString()
          : type.stockType == "Hard Pack" ? "nombre de pack(s)"
          : type.stockType == "Soft" ? "nombre de bouteille(s)"
          : type.stockType == "Soft Pack" ? "nombre de pack(s)"
          : "";

      list.add(
        Card(
            margin: EdgeInsets.all(5),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(type.stockName, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(info, style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.8), fontSize: 15),),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () {
                          if(quantity != 0) {
                            quantity -= 1;
                            type.stockQuant -= 1;
                            stocks.addSaveStock(type);
                            setState(() {});
                          }
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.remove,
                        ),
                        shape: CircleBorder(),
                      ),
                      Text(quantity.toString(), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                      RawMaterialButton(
                        onPressed: () {
                          quantity += 1;
                          type.stockQuant += 1;
                          stocks.addSaveStock(type);
                          setState(() {});
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.add,
                        ),
                        shape: CircleBorder(),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      );
    }) : Container();

    if(listOfType.isNotEmpty) return list;
    else return [Text("Aucun élément de type " + type.toLowerCase() + " en reserve")];
  }
}

