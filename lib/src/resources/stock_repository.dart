import 'dart:async';

import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/resources/stock_api_provider.dart';
import 'package:meta/meta.dart';


class StockRepository {
  final StockApiProvider stockApiProvider;

  StockRepository({@required this.stockApiProvider})
      : assert(stockApiProvider != null);

  Future<List<StockModel>> fetchStocks() async {
    return stockApiProvider.fetchStocksList();
  }

  Future<StockModel> saveStock(StockModel stock) async {
    return stockApiProvider.addStock(stock);
  }
}