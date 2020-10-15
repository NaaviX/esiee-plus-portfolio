import 'dart:async';

import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:meta/meta.dart';

import 'club_api_provider.dart';


class ClubRepository {
  final ClubApiProvider clubApiProvider;

  ClubRepository({@required this.clubApiProvider})
      : assert(clubApiProvider != null);

  Future<List<ClubModel>> fetchClubs() async {
    return clubApiProvider.fetchClubList();
  }

  Future<ClubModel> fetchClub(String mail) async {
    return clubApiProvider.fetchClubByMail(mail);
  }

  Future<ClubModel> saveClub(ClubModel club) async {
    return clubApiProvider.updateClub(club);
  }
}