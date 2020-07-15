import 'package:barcode_scan/barcode_scan.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:bde_esiee_mobile/src/ui/roles/search_contributor.dart';
import 'package:bde_esiee_mobile/src/ui/student/student_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContributorVerificator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContributorVerificatorState();
  }
}


class ContributorVerificatorState extends State<ContributorVerificator> {
  StudentsBloc studentsBloc = StudentsBloc();

  final searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<StudentModel> allStudents;
  List<StudentModel> contributors;
  List<StudentModel> allStudentsExceptContributors;

  FocusNode currentFocus;

  String filter = "";

  @override
  void initState() {
    studentsBloc.fetchAllStudents();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    studentsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Gestion cotisants BDE"),
        ),
        body:StreamBuilder(
            stream: studentsBloc.allStudents,
            builder: (context,
                AsyncSnapshot<List<StudentModel>> studentSnapshot) {
              if (studentSnapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Container(
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  child: GestureDetector(
                                      onTap: () {
                                        currentFocus = FocusScope.of(context);
                                        currentFocus.unfocus();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: SearchContributor(this),
                                      )
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: _scanButton()
                              ),
                            ]
                        )
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator(),);
            })
    );
  }

  Widget _scanButton() {
    return
      RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          padding : EdgeInsets.only(
              top: 16, bottom: 16, left: 7, right: 7),

          color: Theme.of(context).primaryColor,
          child: Icon(Icons.credit_card, color: Background),
          splashColor: Colors.white,
          onPressed: () {
            scan();
          });
  }

  String barcode = "";

  Future scan() async {
    try {
      String idStudent = await BarcodeScanner.scan();
      StudentModel student =  allStudents.firstWhere((element) => element.idStudent.toString() == idStudent) ?? StudentModel();
      showDialog<void>(
          context: context,
          barrierDismissible: true,
          // user must tap button!
          builder: (BuildContext context) {
            return StudentDetail(student);
          }
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}