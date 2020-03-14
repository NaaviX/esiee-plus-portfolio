import 'package:bde_esiee_mobile/src/models/grades_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GradesBloc {
  final _repository = Repository();
  final _gradesFetcher = PublishSubject<List<GradesModel>>();

  Observable<List<GradesModel>> get allGrades => _gradesFetcher.stream;

  fetchAllGrades() async {
    List<GradesModel> gradesModel = await _repository.fetchAllGrades();
    _gradesFetcher.sink.add(gradesModel);
  }

  dispose() {
    _gradesFetcher.close();
  }
}

final bloc = GradesBloc();
