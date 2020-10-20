import 'package:bde_esiee_mobile/src/App.dart';
import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/blocs/stock_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/stock_event.dart';
import 'package:bde_esiee_mobile/src/blocs/stock_state.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/KeeAlivePage.dart';
import 'package:bde_esiee_mobile/src/ui/roles/log/stock_add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Stocks extends StatefulWidget {
  final StockBloc bloc;

  Stocks({Key key, @required this.bloc})
      : assert(bloc != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StocksState();
  }
}

class StocksState extends State<Stocks> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    BlocProvider.of<StockBloc>(context).add(StockRequested());
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                    icon: Icon(
                      FontAwesomeIcons.shoppingCart,
                    ),
                    text: "Tac",
                  ),
                  Tab(icon: Icon(FontAwesomeIcons.cocktail), text: "Reserve"),
                ],
              ),
              title: Text("Stock"),
            ),
            body: Container(child:
            BlocBuilder<StockBloc, StockState>(builder: (context, state) {
              if (state is StockInitial) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is StockLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is StockLoadSuccess) {
                final stocks = state.stocks;

                return TabBarView(
                  controller: _tabController,
                  children: [
                    KeepAlivePage(child: Tac(context, stocks)),
                    KeepAlivePage(child: Reserve(context, stocks)),
                  ],
                );
              }
              if (state is StockLoadFailure) {
                signOutGoogle();
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return App();
                }));
                /*return Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                );*/
              }
              return Container();
            })),
            floatingActionButton: _bottomButtons()));
  }

  Widget _bottomButtons() {
    return FloatingActionButton(
      //shape: StadiumBorder(),
        onPressed: () => showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AddStock(stocksBloc: widget.bloc);
            }),
        child: Icon(
          Icons.add_shopping_cart,
          size: 20.0,
        ));
  }
}

// ignore: must_be_immutable
class Tac extends StatefulWidget {
  List<StockModel> stocks;

  Tac(context, this.stocks);

  @override
  State<StatefulWidget> createState() {
    return TacState();
  }
}

class TacState extends State<Tac> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "Cannettes",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          Column(
            children: _list(context, widget.stocks, "Cannette"),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Snacks",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          Column(
            children: _list(context, widget.stocks, "Snack"),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Autres",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "DLC = Date Limite de Consomation",
            style: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                fontSize: 15),
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            children: _list(context, widget.stocks, "Autre"),
          ),
        ],
      ),
    );
    /*}
              else return Center(child: CircularProgressIndicator());
            })
    );*/
  }

  _list(context, List<StockModel> stocks, String type) {
    List<Widget> list = List<Widget>();
    List<StockModel> listOfType = List<StockModel>();

    stocks.forEach((element) {
      if (element.stockType == type) listOfType.add(element);
    });

    listOfType.isNotEmpty
        ? listOfType.forEach((type) {
      int quantity = type.stockQuant.toInt();

      String info = type.stockType == "Cannette"
          ? "nombre de pallette(s)"
          : type.stockType == "Snack"
          ? "nombre de boite(s)"
          : type.stockType == "Autre"
          ? "DLC : " +
          DateFormat('dd-MM-yyyy', "fr FR").format(type.date)
          : type.stockType == "Hard"
          ? "bouteille(s) de " + type.bottleQuant.toString()
          : type.stockType == "Hard Pack"
          ? "nombre de pack(s)"
          : type.stockType == "Soft"
          ? "nombre de bouteille(s)"
          : type.stockType == "Soft Pack"
          ? "nombre de pack(s)"
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
                      Text(
                        type.stockName,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        info,
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.8),
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxWidth: 50),
                        child: MaterialButton(
                          onPressed: () {
                            if (quantity != 0) {
                              quantity -= 1;
                              type.stockQuant -= 1;
                              BlocProvider.of<StockBloc>(context)
                                  .add(StockToBeSaved(stock: type));
                              setState(() {});
                            }
                          },
                          color: Colors.white,
                          elevation: 2.0,
                          child: Text(
                            "-", style: TextStyle(fontSize: 30, color: MyTheme.colorTheme(context, colorDark: MyTheme.PrimaryColorLight)),
                          ),
                          shape: CircleBorder(),
                        ),
                      ),
                      Container(
                        width: 25,
                        alignment: Alignment.center,
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 50),
                        child: MaterialButton(
                          onPressed: () {
                            quantity += 1;
                            type.stockQuant += 1;
                            BlocProvider.of<StockBloc>(context)
                                .add(StockToBeSaved(stock: type));
                            setState(() {});
                          },
                          color: Colors.white,
                          elevation: 2.0,
                          child: Text(
                            "+", style: TextStyle(fontSize: 30, color: MyTheme.colorTheme(context, colorDark: MyTheme.PrimaryColorLight)),
                          ),
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      );
    })
        : Container();

    if (listOfType.isNotEmpty)
      return list;
    else
      return [
        Text("Aucun élément de type " + type.toLowerCase() + " en reserve")
      ];
  }
}

class Reserve extends StatefulWidget {
  final List<StockModel> stocks;

  Reserve(context, this.stocks);

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
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButton<String>(
            dropdownColor: Theme.of(context).backgroundColor,
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
                child: Text(role,
                    style: TextStyle(
                        color: role == selected ? MyTheme.colorTheme(context, colorLight: Colors.black, colorDark: Colors.white)
                            :  MyTheme.colorTheme(context, colorLight: Colors.black54, colorDark: Colors.white54),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
          SizedBox(
            height: 10,
          ),
          selected == "Hard" ? _hard(context, widget.stocks) : Container(),
          selected == "Soft" ? _soft(context, widget.stocks) : Container(),
        ],
      ),
    );
    /*}
              else return Container();
            })
    );*/
  }

  _hard(context, List<StockModel> stocks) {
    return Column(children: [
      Text(
        "Hard Pack",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
      Column(
        children: _list(context, stocks, "Hard Pack"),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        "Hard",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
      Column(
        children: _list(context, stocks, "Hard"),
      ),
    ]);
  }

  _soft(context, List<StockModel> stocks) {
    return Column(children: [
      Text(
        "Soft Pack",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
      Column(
        children: _list(context, stocks, "Soft Pack"),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        "Soft",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
      Column(
        children: _list(context, stocks, "Soft"),
      ),
    ]);
  }

  _list(context, List<StockModel> stocks, String type) {
    List<Widget> list = List<Widget>();
    List<StockModel> listOfType = List<StockModel>();

    stocks.forEach((element) {
      if (element.stockType == type) listOfType.add(element);
    });

    listOfType.isNotEmpty
        ? listOfType.forEach((type) {
      int quantity = type.stockQuant.toInt();

      String info = type.stockType == "Cannette"
          ? "nombre de pallette(s)"
          : type.stockType == "Snack"
          ? "nombre de boite(s)"
          : type.stockType == "Autre"
          ? "DLC : " +
          DateFormat('dd-MM-yyyy', "fr FR").format(type.date)
          : type.stockType == "Hard"
          ? "bouteille(s) de " + type.bottleQuant.toString()
          : type.stockType == "Hard Pack"
          ? "nombre de pack(s)"
          : type.stockType == "Soft"
          ? "nombre de bouteille(s)"
          : type.stockType == "Soft Pack"
          ? "nombre de pack(s)"
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
                      Text(
                        type.stockName,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        info,
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.8),
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxWidth: 50),
                        child: MaterialButton(
                          onPressed: () {
                            if (quantity != 0) {
                              quantity -= 1;
                              type.stockQuant -= 1;
                              BlocProvider.of<StockBloc>(context)
                                  .add(StockToBeSaved(stock: type));
                              setState(() {});
                            }
                          },
                          color: Colors.white,
                          elevation: 2.0,
                          child: Text(
                            "-", style: TextStyle(fontSize: 30, color: MyTheme.colorTheme(context, colorDark: MyTheme.PrimaryColorLight)),
                          ),
                          shape: CircleBorder(),
                        ),
                      ),
                      Container(
                        width: 25,
                        alignment: Alignment.center,
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 50),
                        child: MaterialButton(
                          onPressed: () {
                            quantity += 1;
                            type.stockQuant += 1;
                            BlocProvider.of<StockBloc>(context)
                                .add(StockToBeSaved(stock: type));
                            setState(() {});
                          },
                          color: Colors.white,
                          elevation: 2.0,
                          child: Text(
                            "+", style: TextStyle(fontSize: 30, color: MyTheme.colorTheme(context, colorDark: MyTheme.PrimaryColorLight)),
                          ),
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      );
    })
        : Container();

    if (listOfType.isNotEmpty)
      return list;
    else
      return [
        Text("Aucun élément de type " + type.toLowerCase() + " en reserve")
      ];
  }
}
