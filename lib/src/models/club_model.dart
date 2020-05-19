import 'package:bde_esiee_mobile/src/models/role_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:logging/logging.dart';

class ClubModel {
  final log = Logger('clubModel');



  int idClubRef;
  String idClub;
  String name;
  String mail;

  double price;
  String contact;
  double solde;
  String description;
  String urlPhoto;
  List<RoleModel> roles;
  List<StudentModel> students;
  ClubModel({
    this.idClubRef,
    this.idClub,
    this.name,
    this.mail,
    this.price,
    this.contact,
    this.solde,
    this.description,
    this.urlPhoto,
    this.roles,
    this.students
  });

  factory ClubModel.fromJson(Map<String, dynamic> parsedJson) {
    ClubModel e = new ClubModel();

    if (parsedJson != null) {
      e.idClubRef = parsedJson["idClubRef"];
      e.idClub = parsedJson["idClub"];
      e.name = parsedJson["name"];
      e.mail = parsedJson["mail"];
      if(parsedJson["price"] == null) {
        e.price = 0;
      } else {
        e.price = parsedJson["price"];
      }
      e.contact = parsedJson["contact"];
      if(parsedJson["solde"] == null) {
        e.solde = 0;
      } else {
        e.solde = parsedJson["solde"];
      }

      e.description = parsedJson["description"];
      e.urlPhoto = parsedJson["url_photo"];
      if(e.urlPhoto == null) {
        e.urlPhoto = "";
      }

      e.roles = RoleModel.allRolesFromJson(parsedJson["roles"]);
      e.students = StudentModel.allStudentsFromJson(parsedJson["students"]);
    }

    return e;
  }

  static List<ClubModel> allClubsFromJson(List<dynamic> jsonData) {
    return new List<ClubModel>.from(
        jsonData.map((x) => ClubModel.fromJson(x)));
  }

}