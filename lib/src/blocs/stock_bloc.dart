import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class StockBloc {
  final _repository = Repository();
  final _stocksAllFetcher = PublishSubject<List<StockModel>>();

  Observable<List<StockModel>> get allStocks => _stocksAllFetcher.stream;

  fetchAllStocks() async {
    List<StockModel> stocks = await _repository.fetchStocks();
    print(stocks);
    _stocksAllFetcher.sink.add(stocks);
  }

  addSaveStock(StockModel stock) async {
    StockModel stockmodel = await _repository.addSaveStock(stock);
  }

  dispose() {
    _stocksAllFetcher.close();
  }
}
