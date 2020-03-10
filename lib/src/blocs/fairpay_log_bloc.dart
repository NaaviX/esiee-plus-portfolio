import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class FairpayLogBloc {
  final _repository = Repository();
  final _FairpayLogFetcher = PublishSubject<List<FairpayLogModel>>();

  Observable<List<FairpayLogModel>> get allFairpayLog => _FairpayLogFetcher.stream;

  fetchAllLogs() async {
    List<FairpayLogModel> fairpaylogmodel = await _repository.fetchFairpayLogs();
    _FairpayLogFetcher.sink.add(fairpaylogmodel);
  }

  dispose() {
    _FairpayLogFetcher.close();
  }
}
