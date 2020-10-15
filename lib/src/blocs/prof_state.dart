import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:meta/meta.dart';

abstract class ProfState  {
  const ProfState();

}

class ProfsInitial extends ProfState {}

class ProfsLoadInProgress extends ProfState {}

class ProfsLoadSuccess extends ProfState {
  final List<ProfModel> profs;

  const ProfsLoadSuccess({@required this.profs}) : assert(profs != null);

}

class ProfsLoadFailure extends ProfState {}

class ProfLoadFailure extends ProfState {}

class ProfInitial extends ProfState {}

class ProfLoadInProgress extends ProfState {}

class ProfLoadSuccess extends ProfState {
  final ProfModel prof;

  const ProfLoadSuccess({@required this.prof}) : assert(prof != null);

}




class ProfSaveLoadInProgress extends ProfState {}
class ProfSaveLoadSuccess extends ProfState {
  final ProfModel prof;

  const ProfSaveLoadSuccess({@required this.prof}) : assert(prof != null);

}




class ProfSaveLoadFailure extends ProfState {}

