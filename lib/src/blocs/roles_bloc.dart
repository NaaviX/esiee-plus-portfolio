import 'package:bde_esiee_mobile/src/blocs/roles_event.dart';
import 'package:bde_esiee_mobile/src/blocs/roles_state.dart';
import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/resources/role_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final RoleRepository roleRepository;

  RolesBloc({@required this.roleRepository})
      : assert(roleRepository != null),
        super(RolesInitial());

  @override
  Stream<RolesState> mapEventToState(RolesEvent event) async* {
    if (event is RolesRequested) {
      yield RolesLoadInProgress();
      try {
        final List<RoleModel> roles = await roleRepository.fetchRoles();
        yield RolesLoadSuccess(roles: roles);
      } catch (_) {
        yield RolesLoadFailure();
      }
    }
  }
}
