import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:meta/meta.dart';
abstract class RolesEvent {
  const RolesEvent();
}

class RolesRequested extends RolesEvent {

  const RolesRequested();

}