import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class JwtBloc {
  final _repository = Repository();
  final _tokenFetcher = PublishSubject<String>();

  Observable<String> get token => _tokenFetcher.stream;

  authenticate(String username, String password) async {
    String token = await _repository.authenticate(username, password);
    _tokenFetcher.sink.add(token);
  }

  register(String username, String password) async {
    await _repository.register(username, password);
  }

  dispose() {
  }
}
