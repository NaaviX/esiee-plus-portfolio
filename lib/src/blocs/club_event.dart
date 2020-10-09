import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:meta/meta.dart';
abstract class ClubEvent {
  const ClubEvent();
}

class ClubRequested extends ClubEvent {

  final String mail;
  const ClubRequested({@required this.mail}) : assert(mail != null);

}

class ClubsRequested extends ClubEvent {

  const ClubsRequested();

}
class ClubToBeSaved extends ClubEvent {
  final ClubModel club;
  const ClubToBeSaved({@required this.club}) : assert(club != null);

}