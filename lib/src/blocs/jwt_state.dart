import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:meta/meta.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';

abstract class JwtState  {
  const JwtState();

}

class JwtAuthenticateInitial extends JwtState {}

class JwtAuthenticateInProgress extends JwtState {}

class JwtAuthenticateSuccess extends JwtState {
  final String token;

  const JwtAuthenticateSuccess({@required this.token}) : assert(token != null);

}

class JwtAuthenticateFailure extends JwtState {}
