import 'dart:async';
import 'dart:io';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

import '../App.dart';


class StockApiProvider {
  final log = Logger('stockAPI');
  static const baseUrl = 'http://193.70.84.159:8080/api-1-SNAPSHOT';
  final Client client;

  StockApiProvider({
  @required this.client,
  }) : assert(client != null);

  Future<List<StockModel>> fetchStocksList() async {
    final response = await client.get("$baseUrl/stock/stocks",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      return StockModel.allUnitsFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  Future<StockModel> addStock(StockModel stock) async {
    final response = await client.post(
        "$baseUrl/stock/update",
        body: {
          "id" : stock.idStock.toString(),
          "date" : DateFormat("yyyy-MM-dd HH:mm:ss","en_US").format(stock.date),
          "type" : stock.stockType,
          "name" : stock.stockName,
          "quantity" : stock.stockQuant.toString(),
          "bottleQuantity" : stock.bottleQuant.toString(),
        },
        headers: {
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      return StockModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }
}