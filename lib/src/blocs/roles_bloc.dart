import 'package:bde_esiee_mobile/src/models/role_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class RolesBloc {
  final _repository = Repository();
  final _rolesFetcher = PublishSubject<List<RoleModel>>();

  Observable<List<RoleModel>> get allRoles => _rolesFetcher.stream;

  fetchAllRoles() async {
    List<RoleModel> rolemodel = await _repository.fetchAllRoles();
    _rolesFetcher.sink.add(rolemodel);
  }

  dispose() {
    _rolesFetcher.close();
  }
}
