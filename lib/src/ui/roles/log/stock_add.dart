import 'package:bde_esiee_mobile/src/blocs/stock_bloc.dart';
import 'package:bde_esiee_mobile/src/blocs/stock_event.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddStock extends StatefulWidget {
  final StockBloc stocksBloc;

  AddStock({Key key, @required this.stocksBloc})
      : assert(stocksBloc != null),
        super(key: key);

  @override
  AddStockState createState() {
    return AddStockState();
  }
}
class AddStockState extends State<AddStock> {

  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final type = TextEditingController();
  final quant = TextEditingController();
  final bottleQuant = TextEditingController();

  DateTime date = DateTime.now();

  String selectedChoices = "Cannette";

  @override Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, appState, child)
        {
          return MaterialApp(
              theme: MyTheme.defaultTheme,
              darkTheme: MyTheme.darkTheme,
              themeMode:
              appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 20.0,
                child: Form(
                    key: _formKey,
                    child: _form(context)
                ),
              )
          );
        }
    );
  }

  List<String> stockType = ["Cannette", "Snack", "Autre", "Soft", "Soft Pack", "Hard", "Hard Pack"];
  _form(context) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(
                left: 20, top: 20, right: 20, bottom: 20),
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomTextFormField(
                        "Nom",
                        "Coca",
                        null,
                        name,
                        type: "titre",
                        requiredField: true,
                        maxLength: 10,
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        children: _buildChoiceList(stockType),
                      ),
                      CustomTextFormField(
                        _quantite(),
                        "0",
                        FontAwesomeIcons.cubes,
                        quant,
                        type: "titre",
                        requiredField: true,
                        maxLength: 4,
                        keyboard: TextInputType.number,
                      ),
                      SizedBox(height: 15.0),
                      selectedChoices == "Hard" || selectedChoices == "Hard Pack" || selectedChoices == "Soft" || selectedChoices == "Soft Pack" ?
                      CustomTextFormField(
                        "Quantité/bouteille",
                        "0",
                        FontAwesomeIcons.wineBottle,
                        bottleQuant,
                        type: "titre",
                        requiredField: false,
                        maxLength: 4,
                        keyboard: TextInputType.number,
                      ) : Container(),
                      selectedChoices == "Autre" || selectedChoices == "Snack" ?
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                200.0)),
                        elevation: 2.0,
                        onPressed: callDatePickerStart,
                        child: Row(children: <Widget>[
                          Text("Date de péremption"),
                          DateFormat('dd/MM/yyyy').format(date) != DateFormat('dd/MM/yyyy').format(DateTime.now()) ? Text(" : " + DateFormat('dd/MM/yyyy').format(date)) : Container(),
                        ],),
                        color: Theme.of(context).backgroundColor,
                      ) : Container(),
                      selectedChoices != "Cannette" ?
                      SizedBox(height: 15.0) : Container(),
                      _buttonAdd(context),
                    ]
                )
            )
        )
    );
  }

  _quantite() {
    String q;
    selectedChoices == "Hard"  || selectedChoices == "Soft" ? q = "Nombre de bouteille(s)" :
    selectedChoices == "Soft Pack" || selectedChoices == "Hard Pack"  ? q = "Nombre de pack(s)" :
    selectedChoices == "Snack" ? q = "Nombre de boite(s)" :
    selectedChoices == "Cannette" ? q = "Nombre de palette(s)" : q = "Quantité";
    return q;
  }

  callDatePickerStart() async {
    var order = await getDate(date);
    setState(() {
      order = new DateTime(
          order.year, order.month, order.day, 1, 0);
      if (order.isAfter(DateTime.now())) {
        date = order;
      }
    });
  }

  Future<DateTime> getDate(DateTime date) {
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2018),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  List<Widget> _buildChoiceList(List<String> units) {
    List<Widget> choices = List<Widget>();

    units.isNotEmpty ?
    units.forEach((item) {
      choices.add(
          Container(
              padding: const EdgeInsets.all(2.0),
              child: ChoiceChip(
                pressElevation: 5.0,
                label: Text(item, style: TextStyle(fontSize: 13),),
                selected: selectedChoices == item,
                onSelected: (bool selected) {
                  setState(() {
                    selectedChoices = selected ? item : null;
                  });
                },
              )));
    }) : choices.add(Container());
    return choices;
  }

  _buttonAdd(context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
                padding: EdgeInsets.all(8),
                color: MyTheme.PrimaryColorLight,
                child: Icon(Icons.add_shopping_cart, color: Colors.white,),
                splashColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    StockModel stock = StockModel(
                      idStock: 0,
                      stockName: name.text,
                      stockType: selectedChoices,
                      date: date,
                      stockQuant: double.parse(quant.text),
                      bottleQuant: bottleQuant.text == "" ? 0 : double.parse(bottleQuant.text),
                    );
                    widget.stocksBloc.add(StockToBeSaved(stock: stock));
                    Navigator.of(context).pop();
                  }
                }
            ),
            RaisedButton(
                padding: EdgeInsets.all(8),
                color: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
                splashColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            )
          ],
        )
    );
  }
}