import 'package:bde_esiee_mobile/src/models/unit_model.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:meta/meta.dart';
abstract class UnitEvent {
  const UnitEvent();
}

class UnitsRequested extends UnitEvent {

  const UnitsRequested();

}