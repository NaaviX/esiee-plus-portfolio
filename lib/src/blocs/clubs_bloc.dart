import 'package:bde_esiee_mobile/src/models/club_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ClubsBloc {
  final _repository = Repository();
  final _clubsFetcher = PublishSubject<List<ClubModel>>();
  final _clubFetcher = PublishSubject<ClubModel>();

  Observable<List<ClubModel>> get allClubs => _clubsFetcher.stream;
  Observable<ClubModel> get thisClub => _clubFetcher.stream;

  fetchAllClubs() async {
    List<ClubModel> clubmodel = await _repository.fetchAllClubs();
    _clubsFetcher.sink.add(clubmodel);
  }

  fetchClub(String email) async {
    List<ClubModel> clubModel = await _repository.fetchAllClubs();
    for(ClubModel c in clubModel) {
      if(c.email.contains(email)) {
        _clubFetcher..sink.add(c);
      }
    }
  }

  dispose() {
    _clubsFetcher.close();
    _clubFetcher.close();
  }
}
