import 'package:bde_esiee_mobile/src/models/club_model.dart';

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

  Future<bool> isClub(String email) async {
    List<ClubModel> clubmodel = await _repository.fetchAllClubs();
    for(ClubModel c in clubmodel) {
      if(c.email.contains(email)) {
        return true;
      }
    }
    return false;
  }

  Future<ClubModel> getClub(String email) async {
    List<ClubModel> clubModel = await _repository.fetchAllClubs();
    for(ClubModel c in clubModel) {
      if(c.email.contains(email)) {
        return c;
      }
    }
    return null;
  }

  dispose() {
    _clubsFetcher.close();
  }
}

final bloc = ClubsBloc();
