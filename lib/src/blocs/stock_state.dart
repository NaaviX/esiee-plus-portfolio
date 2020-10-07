import 'package:meta/meta.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';

abstract class StockState  {
  const StockState();

}

class StockInitial extends StockState {}

class StockLoadInProgress extends StockState {}

class StockLoadSuccess extends StockState {
  final List<StockModel> stocks;

  const StockLoadSuccess({@required this.stocks}) : assert(stocks != null);

}

class StockLoadFailure extends StockState {}



class StockSaveLoadSuccess extends StockState {
  final StockModel stock;

  const StockSaveLoadSuccess({@required this.stock}) : assert(stock != null);

}




class StockSaveLoadFailure extends StockState {}

