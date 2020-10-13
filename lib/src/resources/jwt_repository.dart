import 'dart:async';
import 'package:meta/meta.dart';
import 'jwt_api_provider.dart';


class JwtRepository {
  final JwtApiProvider jwtApiProvider;

  JwtRepository({@required this.jwtApiProvider})
      : assert(jwtApiProvider != null);

  Future<String> authenticateJwt(String username, String password) async {
    return jwtApiProvider.authenticate(username, password);
  }
}