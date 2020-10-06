import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:meta/meta.dart';

abstract class RolesState  {
  const RolesState();

}

class RolesInitial extends RolesState {}

class RolesLoadInProgress extends RolesState {}

class RolesLoadSuccess extends RolesState {
  final List<RoleModel> roles;

  const RolesLoadSuccess({@required this.roles}) : assert(roles != null);

}

class RolesLoadFailure extends RolesState {}

