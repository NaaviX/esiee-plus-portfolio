import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

class JwtApiProvider {
  final log = Logger('jwtAPI');
  static const baseUrl = 'http://193.70.84.159:8080/api-1-SNAPSHOT';
  final Client client;

  JwtApiProvider({
    @required this.client,
  }) : assert(client != null);

  //return token
  Future<String> authenticate(String username, String password) async {
    print("authenticateAAAAAAAAAA");
    await client.post("$baseUrl/register",
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }));

    final response = await client.post(
      "$baseUrl/authenticate",
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }));

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes))["token"]);
      return json.decode(utf8.decode(response.bodyBytes))["token"];
    } else {
      return null;
    }
  }
}
