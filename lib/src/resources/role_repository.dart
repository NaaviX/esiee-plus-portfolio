import 'dart:async';

import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/resources/role_api_provider.dart';
import 'package:meta/meta.dart';


class RoleRepository {
  final RoleApiProvider roleApiProvider;

  RoleRepository({@required this.roleApiProvider})
      : assert(roleApiProvider != null);

  Future<List<RoleModel>> fetchRoles() async {
    return roleApiProvider.fetchRoleList();
  }
}