import 'package:bde_esiee_mobile/src/blocs/prof_event.dart';
import 'package:bde_esiee_mobile/src/blocs/prof_state.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/resources/prof_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';

class ProfsBloc extends Bloc<ProfEvent, ProfState> {
  final ProfRepository profRepository;

  ProfsBloc({@required this.profRepository})
      : assert(profRepository != null),
        super(ProfsInitial());

  @override
  Stream<ProfState> mapEventToState(ProfEvent event) async* {
    if (event is ProfRequested) {
      yield ProfLoadInProgress();
      try {
        final ProfModel prof = await profRepository.fetchProf(event.mail);
        yield ProfLoadSuccess(prof: prof);
      } catch (_) {
        yield ProfLoadFailure();
      }
    }

    if (event is ProfsRequested) {
      yield ProfsLoadInProgress();
      try {
        final List<ProfModel> profs = await profRepository.fetchProfs();
        yield ProfsLoadSuccess(profs: profs);
      } catch (_) {
        yield ProfsLoadFailure();
      }
    }

    else if (event is ProfToBeSaved) {
      yield ProfSaveLoadInProgress();
      try {
        await profRepository.saveProf(event.prof);
        yield ProfSaveLoadSuccess(prof: event.prof);
      } catch (_) {
        print(_);
        yield ProfSaveLoadFailure();
      }
    }
  }
}