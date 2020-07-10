import 'package:logging/logging.dart';

class StockModel {
  final log = Logger('StockModel');

  int idStock;
  DateTime date;
  String stockType;
  String stockName;
  double stockQuant;
  double bottleQuant;

  StockModel({
    this.idStock,
    this.date,
    this.stockType,
    this.stockName,
    this.stockQuant,
    this.bottleQuant,
  });

  factory StockModel.fromJson(Map<String, dynamic> parsedJson) {
    StockModel e = new StockModel();

    if (parsedJson != null) {
      e.idStock = parsedJson["id"];
      e.date = DateTime.parse(parsedJson["date"]);
      e.stockType = parsedJson["type"];
      e.stockName = parsedJson["name"];
      e.stockQuant = parsedJson["quantity"];
      e.bottleQuant = parsedJson["bottleQuantity"];
    }

    return e;
  }

  static List<StockModel> allUnitsFromJson(List<dynamic> jsonData) {
    return new List<StockModel>.from(
        jsonData.map((x) => StockModel.fromJson(x)));
  }

  static StockModel stockFromJson(dynamic jsonData) {
    return new StockModel.fromJson(jsonData);
  }

  @override
  int get hashCode =>
      idStock.hashCode ^
      date.hashCode ^
      stockType.hashCode ^
      stockName.hashCode ^
      stockQuant.hashCode ^
      bottleQuant.hashCode;
}