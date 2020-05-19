import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class FreeRoomsBloc {
  final _repository = Repository();
  final _frAllFetcher = PublishSubject<List<dynamic>>();

  Observable<List<dynamic>> get allRoomsLog => _frAllFetcher.stream;

  fetchAllRooms() async {
    List<dynamic> freerooms = await _repository.fetchFreeRooms();
    _frAllFetcher.sink.add(freerooms);
  }

  dispose() {
    _frAllFetcher.close();
  }
}
