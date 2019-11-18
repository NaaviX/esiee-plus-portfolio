import 'package:bde_esiee_mobile/src/models/gradesUnit_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GradesUnitBloc {
  static String gradesID;
  GradesUnitBloc({gradesID});

  final _repository = Repository();

  final _gradesUnitFetcher = PublishSubject<List<GradesUnitModel>>();

  Observable<List<GradesUnitModel>> get allGradesUnit => _gradesUnitFetcher.stream;

  fetchAllGradesUnit(String gradesID) async {
    List<GradesUnitModel> gradesUnitModel = await _repository.fetchAllGradesUnit();
    _gradesUnitFetcher.sink.add(gradesUnitModel);
  }

  dispose() {
    _gradesUnitFetcher.close();
  }
}

final bloc = GradesUnitBloc();
