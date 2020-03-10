import 'dart:async';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'dart:convert';

class FairpayLogApiProvider {
  final log = Logger('fairpayLogAPI');
  Client client = Client();

  Future<List<FairpayLogModel>> fetchFairpayLogList() async {
    final response = await client.get("http://137.74.197.140:8080/api-1-SNAPSHOT/fairpay/logs");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return FairpayLogModel.allFairpayLogFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
