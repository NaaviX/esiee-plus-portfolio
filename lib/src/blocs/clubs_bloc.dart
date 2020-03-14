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
    ClubModel clubModel = await _repository.fetchClubByMail(email);
    _clubFetcher..sink.add(clubModel);
  }

  fetchClubById(int id) async {
    List<ClubModel> clubModel = await _repository.fetchAllClubs();
    for(ClubModel c in clubModel) {
      if(c.idClubRef == id) {
        _clubFetcher..sink.add(c);
      }
    }
  }

  fetchTotalAmount() async {
    List<ClubModel> clubModel = await _repository.fetchAllClubs();
    int total = 0;
    for(ClubModel c in clubModel){
      total += c.solde;
    }
    return total;
  }

  dispose() {
    _clubsFetcher.close();
    _clubFetcher.close();
  }
}
