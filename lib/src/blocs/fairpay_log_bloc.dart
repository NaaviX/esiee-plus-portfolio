import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:bde_esiee_mobile/src/resources/Fairpay/fairpay_log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fairpay_log_event.dart';
import 'fairpay_log_state.dart';

import 'package:meta/meta.dart';


class FairpayLogsBloc extends Bloc<FairpayLogEvent, FairpayLogState> {
  final FairpayLogRepository fairpayLogRepository;

  FairpayLogsBloc({@required this.fairpayLogRepository})
      : assert(fairpayLogRepository != null),
        super(FairpayLogsInitial());

  @override
  Stream<FairpayLogState> mapEventToState(FairpayLogEvent event) async* {
    if (event is FairpayLogsRequested) {
      yield FairpayLogsLoadInProgress();
      try {
        final List<FairpayLogModel> fairpayLogs = await fairpayLogRepository.fetchFairpayLogs();
        yield FairpayLogsLoadSuccess(fairpayLogs: fairpayLogs);
      } catch (_) {
        yield FairpayLogsLoadFailure();
      }
    }

    if (event is FairpayLogsByClubRequested) {
      yield FairpayLogsByClubLoadInProgress();
      try {
        final List<FairpayLogModel> fairpayLogs = await fairpayLogRepository.fetchFairpayLogsByClub(event.id);
        yield FairpayLogsByClubLoadSuccess(fairpayLog: fairpayLogs);
      } catch (_) {
        yield FairpayLogsByClubLoadFailure();
      }
    }

    else if (event is FairpayLogToBeSaved) {
      try {
        await fairpayLogRepository.saveFairpayLog(event.fairpayLog);
      } catch (_) {
        yield FairpayLogSaveLoadFailure();
      }
    }
  }
}

