import 'package:bde_esiee_mobile/src/blocs/unit_event.dart';
import 'package:bde_esiee_mobile/src/blocs/unit_state.dart';
import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/resources/unit_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class UnitsBloc extends Bloc<UnitEvent, UnitState> {
  final UnitRepository unitRepository;

  UnitsBloc({@required this.unitRepository})
      : assert(unitRepository != null),
        super(UnitsInitial());

  @override
  Stream<UnitState> mapEventToState(UnitEvent event) async* {

    if (event is UnitsRequested) {
      yield UnitsLoadInProgress();
      try {
        final List<UnitModel> units = await unitRepository.fetchUnits();
        yield UnitsLoadSuccess(units: units);
      } catch (_) {
        yield UnitsLoadFailure();
      }
    }
  }
}