import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:meta/meta.dart';
abstract class FairpayLogEvent {
  const FairpayLogEvent();
}

class FairpayLogsByClubRequested extends FairpayLogEvent {

  final String id;
  const FairpayLogsByClubRequested({@required this.id}) : assert(id != null);

}

class FairpayLogsRequested extends FairpayLogEvent {

  const FairpayLogsRequested();

}
class FairpayLogToBeSaved extends FairpayLogEvent {
  final FairpayLogModel fairpayLog;
  const FairpayLogToBeSaved({@required this.fairpayLog}) : assert(fairpayLog != null);

}