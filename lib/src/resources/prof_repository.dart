import 'dart:async';

import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/prof_model.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';
import 'package:bde_esiee_mobile/src/resources/prof_api_provider.dart';
import 'package:bde_esiee_mobile/src/resources/stock_api_provider.dart';
import 'package:meta/meta.dart';

import 'club_api_provider.dart';


class ProfRepository {
  final ProfApiProvider profApiProvider;

  ProfRepository({@required this.profApiProvider})
      : assert(profApiProvider != null);

  Future<List<ProfModel>> fetchProfs() async {
    return profApiProvider.fetchProfList();
  }

  Future<ProfModel> fetchProf(String mail) async {
    return profApiProvider.fetchProfByMail(mail);
  }

  Future<ProfModel> saveProf(ProfModel prof) async {
    return profApiProvider.addProf(prof);
  }
}