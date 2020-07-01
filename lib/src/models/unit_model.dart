import 'package:logging/logging.dart';

class UnitModel {
  final log = Logger('UnitModel');

  int idUnit;
  String unitCode;
  String unitName;

  UnitModel({
    this.idUnit,
    this.unitCode,
    this.unitName
  });

  factory UnitModel.fromJson(Map<String, dynamic> parsedJson) {
    UnitModel e = new UnitModel();

    if (parsedJson != null) {
      e.idUnit = parsedJson["idUnit"];
      e.unitCode = parsedJson["unitCode"];
      e.unitName = parsedJson["unitName"];
    }

    return e;
  }

  static List<UnitModel> allUnitsFromJson(List<dynamic> jsonData) {
    return new List<UnitModel>.from(
        jsonData.map((x) => UnitModel.fromJson(x)));
  }

  static UnitModel unitFromJson(dynamic jsonData) {
    return new UnitModel.fromJson(jsonData);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UnitModel &&
              runtimeType == other.runtimeType &&
              idUnit == other.idUnit &&
              unitCode == other.unitCode &&
              unitName == other.unitName;

  @override
  int get hashCode =>
      idUnit.hashCode ^
      unitCode.hashCode ^
      unitName.hashCode;



}