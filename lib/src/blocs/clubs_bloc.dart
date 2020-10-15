import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/resources/club_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        await clubRepository.saveClub(event.club);
      } catch (_) {
        yield ClubSaveLoadFailure();
      }
    }
  }
}
