import 'package:barcode_scan/barcode_scan.dart';
import 'package:bde_esiee_mobile/src/blocs/students_bloc.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/ui/club/student_info.dart';
import 'package:bde_esiee_mobile/src/ui/roles/admin/contributor_add.dart';
import 'package:bde_esiee_mobile/src/ui/custom_widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContributorManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContributorManagerState();
  }
}

class ContributorManagerState extends State<ContributorManager> {
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
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    studentsBloc.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Gestion cotisants BDE"),
        ),
        body: GestureDetector(
            onTap: () {
              currentFocus = FocusScope.of(context);
              currentFocus.unfocus();
            },
            child: StreamBuilder(
                stream: studentsBloc.allStudents,
                builder: (context,
                    AsyncSnapshot<List<StudentModel>> studentSnapshot) {
                  if (studentSnapshot.hasData) {
                    allStudents = studentSnapshot.data;
                    contributors = allStudents.where((element) => element.isContributor).toList();
                    allStudentsExceptContributors = allStudents.where((element) => !contributors.contains(element)).toList();
                    return Column(
                      children: <Widget>[
                        Container(
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                      child: Container(
                                          margin: EdgeInsets.all(2),
                                          child: ContributorAdd(this, allStudentsExceptContributors))),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 10, bottom: 10, right: 10),

                                      child: _scanButton()),
                                ])),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black12))),
                          padding: EdgeInsets.all(10),

                          child:
                          CustomTextFormField(
                            "Rechercher...",
                            "Prenom et/ou nom de l'élève",
                            Icons.search,
                            searchController,
                            focusNode: currentFocus,),),
                        Expanded(
                            child: ListView.builder(
                              itemCount: contributors.length,
                              itemBuilder: (BuildContext context, int index) {
                                StudentModel student = contributors.elementAt(index);
                                filter = searchController.text;
                                return (filter == null || filter == "")
                                    ? _studentTile(student, index)
                                    : (student.firstname
                                    .toLowerCase()
                                    .startsWith(filter.toLowerCase()) ||
                                    student.lastname
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()) ||
                                    (student.firstname + " " + student.lastname)
                                        .toLowerCase()
                                        .startsWith(filter.toLowerCase()))
                                    ? _studentTile(student, index)
                                    : new Container();

                              },
                            )),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator(),);
                })));


  }

  Widget _studentTile(StudentModel student, int index) {
    Color color = (index % 2 == 0) ? Colors.white : Color(0xFFF7F7F9);
    return new Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(color: color),
      child: ListTile(
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.firstname+" "+student.lastname,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  student.mailEsiee.toString(),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]
          ),
          trailing: IconButton(
            color: Colors.red,
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Suppression'),
                    content: Text('Voulez-vous supprimer ce cotisant ?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Oui'),
                        onPressed: () {
                          deleteStudentFromContributor(student);
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Non'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          onTap: () {
            showDialog<void>(
                context: context,
                barrierDismissible: true,
                // user must tap button!
                builder: (BuildContext context) {
                  return StudentDetail(student);
                });
          }
      ),
    );
  }

  void deleteStudentFromContributor(StudentModel student) {
    if(student != null) {
      student.isContributor = false;
      studentsBloc.updateStudent(student);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Cotisant supprimé"),
        backgroundColor: Colors.green,
      ));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Erreur lors de la mise à jour"),
        backgroundColor: Colors.red,
      ));
    }
    setState(() {});
  }

  void addStudentToContributor(StudentModel student) {
    if(student != null) {
      if(!student.isContributor){
        student.isContributor = true;
        studentsBloc.updateStudent(student);
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text("Cotisant ajouté"),
              backgroundColor: Colors.green,
            )
        );
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Erreur lors de la mise à jour"),
        backgroundColor: Colors.red,
      ));
    }
    setState(() {});
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
          child: Icon(Icons.credit_card),
          /*Text(
            'scan'.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),*/
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
      if(!student.isContributor)
        addStudentToContributor(student);
      else _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Cet élève est déjà cotisant"),
            backgroundColor: Colors.green,
          )
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
