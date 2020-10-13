import 'package:meta/meta.dart';
abstract class JwtEvent {
  const JwtEvent();
}

class JwtAuthenticate extends JwtEvent {

  final String username;
  final String password;
  const JwtAuthenticate({@required this.username, @required this.password}) : assert(username != null && password != null);

}

