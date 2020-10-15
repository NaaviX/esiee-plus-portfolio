import 'dart:async';

import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:meta/meta.dart';

import 'unit_api_provider.dart';


class UnitRepository {
  final UnitApiProvider unitApiProvider;

  UnitRepository({@required this.unitApiProvider})
      : assert(unitApiProvider != null);

  Future<List<UnitModel>> fetchUnits() async {
    return unitApiProvider.fetchUnitsList();
  }
}