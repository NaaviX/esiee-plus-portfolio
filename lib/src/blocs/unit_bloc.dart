import 'package:bde_esiee_mobile/src/models/unit_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UnitBloc {
  final _repository = Repository();
  final _unitsAllFetcher = PublishSubject<List<UnitModel>>();

  Observable<List<UnitModel>> get allUnits => _unitsAllFetcher.stream;

  fetchAllUnits() async {
    List<UnitModel> units = await _repository.fetchUnits();
    print(units);
    _unitsAllFetcher.sink.add(units);
  }

  dispose() {
    _unitsAllFetcher.close();
  }
}
