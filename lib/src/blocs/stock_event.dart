import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:meta/meta.dart';
abstract class StockEvent {
  const StockEvent();
}

class StockRequested extends StockEvent {

  const StockRequested();

}
class StockToBeSaved extends StockEvent {
  final StockModel stock;
  const StockToBeSaved({@required this.stock}) : assert(stock != null);

}