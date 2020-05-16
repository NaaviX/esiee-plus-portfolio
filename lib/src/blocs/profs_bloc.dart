import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfsBloc {
  final _repository = Repository();
  final _profsFetcher = PublishSubject<List<ProfModel>>();
  final _profFetcher = PublishSubject<ProfModel>();

  Observable<List<ProfModel>> get allProfs => _profsFetcher.stream;
  Observable<ProfModel> get thisProf => _profFetcher.stream;

  fetchAllProfs() async {
    List<ProfModel> profslist = await _repository.fetchAllProfs();
    print(profslist);
    _profsFetcher.sink.add(profslist);
  }

  fetchProf(String email) async {
    ProfModel profModel = await _repository.fetchProfByMail(email);
    _profFetcher.sink.add(profModel);
  }

  dispose() {
    _profsFetcher.close();
    _profFetcher.close();
  }

  addSaveEvent(ProfModel prof) async {
    ProfModel profmodel = await _repository.addSaveProf(prof);
  }
}
