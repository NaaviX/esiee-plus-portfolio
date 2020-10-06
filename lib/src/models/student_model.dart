import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/user_model.dart';
import 'package:logging/logging.dart';

import 'club_model.dart';

class StudentModel extends UserModel {
  final log = Logger('StudentModel');



  int idStudent;
  String mailEsiee;
  String firstname;
  String lastname;
  String promo;
  String phone;
  bool isContributor;
  String urlPhoto;
  List<RoleModel> roles;
  List<ClubModel> clubs;




  StudentModel({
    this.idStudent,
    this.mailEsiee,
    this.firstname,
    this.lastname,
    this.promo,
    this.phone,
    this.isContributor,
    this.urlPhoto,
    this.roles,
    this.clubs
  });

  factory StudentModel.fromJson(Map<String, dynamic> parsedJson) {
    StudentModel e = new StudentModel();

    if (parsedJson != null) {
      e.idStudent = parsedJson["idStudent"];
      e.mailEsiee = parsedJson["mailEsiee"];
      e.firstname = parsedJson["firstname"];
      e.lastname = parsedJson["lastname"];
      e.promo = parsedJson["promo"];
      e.phone = parsedJson["phone"];
      e.isContributor = parsedJson["contributor"];
      e.urlPhoto = parsedJson["urlPhoto"];
      e.roles = RoleModel.allRolesFromJson(parsedJson["roles"]);
      e.clubs = new List();
    }

    return e;
  }

  static List<StudentModel> allStudentsFromJson(List<dynamic> jsonData) {
    return new List<StudentModel>.from(
        jsonData.map((x) => StudentModel.fromJson(x)));
  }

  @override
  int get hashCode =>
      idStudent.hashCode ^
      mailEsiee.hashCode ^
      firstname.hashCode ^
      lastname.hashCode ^
      promo.hashCode ^
      phone.hashCode ^
      isContributor.hashCode ^
      urlPhoto.hashCode ^
      roles.hashCode ^
      clubs.hashCode;

  @override
  bool operator ==(other) {
    return idStudent == other.idStudent;
  }

}