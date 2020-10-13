import 'dart:async';

import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:meta/meta.dart';

import 'fairpay_log_api_provider.dart';


class FairpayLogRepository {
  final FairpayLogApiProvider fairpayLogApiProvider;

  FairpayLogRepository({@required this.fairpayLogApiProvider})
      : assert(fairpayLogApiProvider != null);

  Future<List<FairpayLogModel>> fetchFairpayLogs() async {
    return fairpayLogApiProvider.fetchFairpayLogList();
  }

  Future<List<FairpayLogModel>> fetchFairpayLogsByClub(String id) async {
    return fairpayLogApiProvider.fetchLogsByClub(id);
  }

  Future<FairpayLogModel> saveFairpayLog(FairpayLogModel fairpayLog) async {
    return fairpayLogApiProvider.addLog(fairpayLog);
  }
}