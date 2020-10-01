import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class JwtApiProvider {
  final log = Logger('roleAPI');
  Client client = Client();

  //return token
  Future<String> authenticate(String username, String password) async {
    print("authAAAAAAAAAA");
    await client.post("http://137.74.197.140:8080/api-2-SNAPSHOT/register",
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }));

    final response = await client.post(
      "http://137.74.197.140:8080/api-2-SNAPSHOT/authenticate",
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
      //await register(username, password);
      return "";
    }
  }

  //return nothing
  Future<void> register(String username, String password) async {
    print("registerAAAAAAAAAA");
    final response = await client.post("http://137.74.197.140:8080/api-2-SNAPSHOT/register",
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }));

    if (response.statusCode == 200) {
      return;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to register');
    }
  }
}
