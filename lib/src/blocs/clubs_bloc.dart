import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/resources/club_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'club_event.dart';
import 'club_state.dart';

import 'package:meta/meta.dart';

class ClubsBloc extends Bloc<ClubEvent, ClubState> {
  final ClubRepository clubRepository;

  ClubsBloc({@required this.clubRepository})
      : assert(clubRepository != null),
        super(ClubsInitial());

  @override
  Stream<ClubState> mapEventToState(ClubEvent event) async* {
    if (event is ClubRequested) {
      yield ClubLoadInProgress();
      try {
        final ClubModel club = await clubRepository.fetchClub(event.mail);
        yield ClubLoadSuccess(club: club);
      } catch (_) {
        yield ClubLoadFailure();
      }
    }

    if (event is ClubsRequested) {
      yield ClubsLoadInProgress();
      try {
        final List<ClubModel> clubs = await clubRepository.fetchClubs();
        yield ClubsLoadSuccess(clubs: clubs);
      } catch (_) {
        yield ClubsLoadFailure();
      }
    }

    else if (event is ClubToBeSaved) {
      try {
        await clubRepository.saveStock(event.club);
      } catch (_) {
        yield ClubSaveLoadFailure();
      }
    }
  }
}

/*
class ClubsBloc {
  final _repository = Repository();
  final _clubsFetcher = PublishSubject<List<ClubModel>>();
  final _clubFetcher = PublishSubject<ClubModel>();

  Observable<List<ClubModel>> get allClubs => _clubsFetcher.stream;
  Observable<ClubModel> get thisClub => _clubFetcher.stream;

  fetchAllClubs() async {
    List<ClubModel> clubmodel = await _repository.fetchAllClubs();
    clubmodel.sort((item1, item2) => item1.name.compareTo(item2.name));
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
    double total = 0;
    for(ClubModel c in clubModel){
      total += c.solde;
    }
    return total;
  }
  addStudentToClub(StudentModel student, ClubModel club) async {
    club.students.add(student);
    await _repository.updateClub(club);
  }
  removeStudentFromClub(StudentModel student, ClubModel club) async {
    club.students.remove(student);
    await _repository.updateClub(club);
  }

  updateClub(ClubModel club) async {
    await _repository.updateClub(club);
  }

  editSolde(ClubModel club, double diff) async {
    club.solde += diff;
    await _repository.updateClub(club);
  }

  dispose() {
    _clubsFetcher.close();
    _clubFetcher.close();
  }
}*/
