import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:meta/meta.dart';

abstract class FairpayLogState  {
  const FairpayLogState();

}

class FairpayLogsInitial extends FairpayLogState {}

class FairpayLogsLoadInProgress extends FairpayLogState {}

class FairpayLogsLoadSuccess extends FairpayLogState {
  final List<FairpayLogModel> fairpayLogs;

  const FairpayLogsLoadSuccess({@required this.fairpayLogs}) : assert(fairpayLogs != null);

}

class FairpayLogsLoadFailure extends FairpayLogState {}

class FairpayLogsByClubLoadFailure extends FairpayLogState {}

class FairpayLogsByClubInitial extends FairpayLogState {}

class FairpayLogsByClubLoadInProgress extends FairpayLogState {}

class FairpayLogsByClubLoadSuccess extends FairpayLogState {
  final List<FairpayLogModel> fairpayLog;

  const FairpayLogsByClubLoadSuccess({@required this.fairpayLog}) : assert(fairpayLog != null);

}





class FairpayLogSaveLoadSuccess extends FairpayLogState {
  final FairpayLogModel fairpayLog;

  const FairpayLogSaveLoadSuccess({@required this.fairpayLog}) : assert(fairpayLog != null);

}




class FairpayLogSaveLoadFailure extends FairpayLogState {}

