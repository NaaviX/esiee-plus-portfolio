
import 'package:meta/meta.dart';

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
