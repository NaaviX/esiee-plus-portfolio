import 'dart:async';
import 'dart:io';
import 'package:bde_esiee_mobile/src/models/fairpay_log_model.dart';
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

import '../../App.dart';

class FairpayLogApiProvider {
  final log = Logger('fairpayLogAPI');
  static const baseUrl = 'http://137.74.197.140:8080/api-2-SNAPSHOT';
  final Client client;

  FairpayLogApiProvider({
    @required this.client,
  }) : assert(client != null);

  Future<List<FairpayLogModel>> fetchFairpayLogList() async {
    final response = await client.get("$baseUrl/fairpay/logs",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return FairpayLogModel.allFairpayLogFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<FairpayLogModel>> fetchLogsByClub(String id) async {
    final response = await client.get("$baseUrl/fairpay/log/"+id,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        });
    log.fine(response.statusCode);
    if (response.statusCode == 200) {
      return FairpayLogModel.allFairpayLogFromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<FairpayLogModel> addLog(FairpayLogModel log) async {
    String url = Uri.encodeFull(
      "$baseUrl/fairpay/log/add?"+
      "date="+ Uri.encodeFull(DateFormat("yyyy-MM-dd HH:mm:ss","en_US").format(DateTime.now())).replaceAll(":", "%3A")+
      "&type="+ log.type+
      "&montant="+ log.amount.toString()+
      "&info="+ Uri.encodeFull(log.info).replaceAll(":", "%3A")+
      "&id_club_ref="+log.idClubRef.toString()
    ).replaceAll("%25", "%");

    final response = await client.post(
      url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer "+Base.token
        }
    );

    if (response.statusCode == 200) {
      return FairpayLogModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update data');
    }
  }
}
