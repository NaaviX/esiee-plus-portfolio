import 'package:logging/logging.dart';

class FairpayLogModel {
  final log = Logger('Fairpay Log');

  int id;
  DateTime date;
  String type;
  double amount;
  String info;
  int idClubRef;

  FairpayLogModel({
    this.id,
    this.date,
    this.type,
    this.amount,
    this.info,
    this.idClubRef
  });

  factory FairpayLogModel.fromJson(Map<String, dynamic> parsedJson) {
    FairpayLogModel e = new FairpayLogModel();

    if (parsedJson != null) {
      e.id = parsedJson["id"];
      e.date = DateTime.parse(parsedJson["date"]);
      e.type = parsedJson["type"];
      e.amount = parsedJson["montant"];
      e.info = parsedJson["info"];
      e.idClubRef = parsedJson["idClubRef"];
    }
    return e;
  }

  static List<FairpayLogModel> allFairpayLogFromJson(List<dynamic> jsonData) {
    return new List<FairpayLogModel>.from(
        jsonData.map((x) => FairpayLogModel.fromJson(x)));
  }

  String get userName{
    List<String> splitDescription = this.info.split(" :: ");
    return splitDescription.length > 1 ? splitDescription[0] : "unknown";
  }

  String get description{
    List<String> splitDescription = this.info.split(" :: ");
    return splitDescription.length > 1 ? splitDescription[1] : splitDescription[0];
  }

}