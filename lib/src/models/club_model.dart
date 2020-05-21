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

  String urlBackground;
  String urlNetwork;
  String urlFB;

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
    this.students,
    this.urlBackground,
    this.urlFB,
    this.urlNetwork
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
      e.urlNetwork = parsedJson["url_network"];
      if(e.urlNetwork == null) {
        e.urlNetwork = "";
      }
      e.urlBackground = parsedJson["url_background"];
      if(e.urlBackground == null) {
        e.urlBackground = "";
      }
      e.urlFB = parsedJson["url_background"];
      if(e.urlFB == null) {
        e.urlFB = "";
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