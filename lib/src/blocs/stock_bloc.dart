import 'package:bde_esiee_mobile/src/blocs/stock_event.dart';
import 'package:bde_esiee_mobile/src/blocs/stock_state.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/resources/stock_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepository stockRepository;

  StockBloc({@required this.stockRepository})
      : assert(stockRepository != null),
        super(StockInitial());

  @override
  Stream<StockState> mapEventToState(StockEvent event) async* {
    if (event is StockRequested) {
      yield StockLoadInProgress();
      try {
        final List<StockModel> stocks = await stockRepository.fetchStocks();
        yield StockLoadSuccess(stocks: stocks);
      } catch (_) {
        yield StockLoadFailure();
      }
    }

    else if (event is StockToBeSaved) {
      try {
        await stockRepository.saveStock(event.stock);
      } catch (_) {
        yield StockSaveLoadFailure();
      }
    }
  }
}
