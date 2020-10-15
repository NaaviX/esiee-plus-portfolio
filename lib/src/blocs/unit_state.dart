import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:meta/meta.dart';

abstract class UnitState  {
  const UnitState();

}

class UnitsInitial extends UnitState {}

class UnitsLoadInProgress extends UnitState {}

class UnitsLoadSuccess extends UnitState {
  final List<UnitModel> units;

  const UnitsLoadSuccess({@required this.units}) : assert(units != null);

}

class UnitsLoadFailure extends UnitState {}