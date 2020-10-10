import 'package:bde_esiee_mobile/src/resources/jwt_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'jwt_event.dart';
import 'jwt_state.dart';
import 'package:meta/meta.dart';

class JwtBloc extends Bloc<JwtEvent, JwtState> {
  final JwtRepository jwtRepository;

  JwtBloc({@required this.jwtRepository})
      : assert(jwtRepository != null),
        super(JwtAuthenticateInitial());

  @override
  Stream<JwtState> mapEventToState(JwtEvent event) async* {
    if (event is JwtAuthenticate) {
      yield JwtAuthenticateInProgress();
      try {
        final String token = await jwtRepository.authenticateJwt(event.username, event.password);
        yield JwtAuthenticateSuccess(token: token);
      } catch (_) {
        yield JwtAuthenticateFailure();
      }
    }
  }
}
