import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class FairpayLogBloc {
  final _repository = Repository();
  final _fpAllLogFetcher = PublishSubject<List<FairpayLogModel>>();
  final _fpLogFetcher =PublishSubject<List<FairpayLogModel>>();

  Observable<List<FairpayLogModel>> get allFairpayLog => _fpAllLogFetcher.stream;
  Observable<List<FairpayLogModel>> get clubFairpayLog => _fpLogFetcher.stream;

  fetchAllLogs() async {
    List<FairpayLogModel> fairpaylogmodel = await _repository.fetchFairpayLogs();
    fairpaylogmodel.sort((item1, item2) => item2.date.compareTo(item1.date));
    _fpAllLogFetcher.sink.add(fairpaylogmodel);
  }

  fetchClubLogs(String id) async {
    List<FairpayLogModel> fairpaylogmodel = await _repository.fetchLogsByClub(id);
    fairpaylogmodel.sort((item1, item2) => item2.date.compareTo(item1.date));
    _fpLogFetcher.sink.add(fairpaylogmodel);
  }

  addLog(FairpayLogModel log) async {
    FairpayLogModel logModel = await _repository.addLog(log);
    return logModel;
  }

  dispose() {
    _fpAllLogFetcher.close();
    _fpLogFetcher.close();
  }
}
