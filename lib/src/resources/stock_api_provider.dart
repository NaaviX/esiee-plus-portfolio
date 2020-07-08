import 'dart:async';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'dart:convert';


class StockApiProvider {
  final log = Logger('stockAPI');
  Client client = Client();

  Future<List<StockModel>> fetchStocksList() async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/stock/stocks");
    if (response.statusCode == 200) {
      return StockModel.allUnitsFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<StockModel> addStock(StockModel stock) async {
    final response = await client.post(
        "http://137.74.197.140:8080/api-1-SNAPSHOT/stock/update",
        body: {
          "id" : stock.idStock.toString(),
          "date" : DateFormat("yyyy-MM-dd HH:mm:ss","en_US").format(stock.date),
          "type" : stock.stockType,
          "name" : stock.stockName,
          "quantity" : stock.stockQuant.toString(),
          "bottleQuantity" : stock.bottleQuant.toString(),
        });
    if (response.statusCode == 200) {
      return StockModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }
}