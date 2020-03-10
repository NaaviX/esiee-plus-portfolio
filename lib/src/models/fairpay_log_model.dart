import 'package:logging/logging.dart';

class FairpayLogModel {
  final log = Logger('Fairpay Log');

  int id;
  DateTime date;
  String type;
  double amount;
  String description;
  int idClubRef;

  FairpayLogModel({
    this.id,
    this.date,
    this.type,
    this.amount,
    this.description,
    this.idClubRef
  });

  factory FairpayLogModel.fromJson(Map<String, dynamic> parsedJson) {
    FairpayLogModel e = new FairpayLogModel();

    if (parsedJson != null) {
      e.id = parsedJson["id"];
      e.date = DateTime.parse(parsedJson["date"]);
      e.type = parsedJson["type"];
      e.amount = parsedJson["montant"];
      e.description = parsedJson["info"];
      e.idClubRef = parsedJson["idClubRef"];
    }
    return e;
  }

  static List<FairpayLogModel> allFairpayLogFromJson(List<dynamic> jsonData) {
    return new List<FairpayLogModel>.from(
        jsonData.map((x) => FairpayLogModel.fromJson(x)));
  }



}