
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:meta/meta.dart';
abstract class ProfEvent {
  const ProfEvent();
}

class ProfRequested extends ProfEvent {

  final String mail;
  const ProfRequested({@required this.mail}) : assert(mail != null);

}

class ProfsRequested extends ProfEvent {

  const ProfsRequested();

}
class ProfToBeSaved extends ProfEvent {
  final ProfModel prof;
  const ProfToBeSaved({@required this.prof}) : assert(prof != null);

}