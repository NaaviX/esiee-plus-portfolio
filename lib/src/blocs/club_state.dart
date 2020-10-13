import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:meta/meta.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';

abstract class ClubState  {
  const ClubState();

}

class ClubsInitial extends ClubState {}

class ClubsLoadInProgress extends ClubState {}

class ClubsLoadSuccess extends ClubState {
  final List<ClubModel> clubs;

  const ClubsLoadSuccess({@required this.clubs}) : assert(clubs != null);

}

class ClubsLoadFailure extends ClubState {}

class ClubLoadFailure extends ClubState {}

class ClubInitial extends ClubState {}

class ClubLoadInProgress extends ClubState {}

class ClubLoadSuccess extends ClubState {
  final ClubModel club;

  const ClubLoadSuccess({@required this.club}) : assert(club != null);

}





class ClubSaveLoadSuccess extends ClubState {
  final ClubModel club;

  const ClubSaveLoadSuccess({@required this.club}) : assert(club != null);

}




class ClubSaveLoadFailure extends ClubState {}

