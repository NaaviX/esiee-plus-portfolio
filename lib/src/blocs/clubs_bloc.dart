import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/event_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ClubsBloc {
  final _repository = Repository();
  final _clubsFetcher = PublishSubject<List<ClubModel>>();

  Observable<List<ClubModel>> get allClubs => _clubsFetcher.stream;

  fetchAllClubs() async {
    List<ClubModel> clubmodel = await _repository.fetchAllClubs();
    _clubsFetcher.sink.add(clubmodel);
  }

  dispose() {
    _clubsFetcher.close();
  }
}

final bloc = ClubsBloc();
