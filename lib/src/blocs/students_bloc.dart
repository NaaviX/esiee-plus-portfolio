import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class StudentsBloc {
  final _repository = Repository();
  final _studentsFetcher = PublishSubject<List<StudentModel>>();
  final _studentsClubFetcher = PublishSubject<List<ClubModel>>();
  final _studentFetcher = PublishSubject<StudentModel>();

  Observable<List<StudentModel>> get allStudents => _studentsFetcher.stream;
  Observable<StudentModel> get thisStudent => _studentFetcher.stream;
  Observable<List<ClubModel>> get thisStudentClubs => _studentsClubFetcher.stream;

  fetchAllStudents() async {
    List<StudentModel> studentmodel = await _repository.fetchAllStudents();
    studentmodel.sort((item1, item2) => item1.lastname.compareTo(item2.lastname));
    _studentsFetcher.sink.add(studentmodel);
  }

  fetchStudent(String email) async {
    StudentModel studentModel = await _repository.fetchStudent(email);
    _studentFetcher.sink.add(studentModel);
  }

  fetchStudentById(String idStudent) async {
    StudentModel studentModel = await _repository.fetchStudentById(idStudent);
    _studentFetcher.sink.add(studentModel);
  }

  updateStudent(StudentModel student) async {
    await _repository.updateStudent(student);
  }

  fetchAllStudentClubs(StudentModel student) async {
    List<ClubModel> studentClubs=await _repository.fetchAllClubs();
    studentClubs.removeWhere((element) => !element.students.contains(student));
    _studentsClubFetcher.sink.add(studentClubs);
  }

  dispose() {
    _studentsClubFetcher.close();
    _studentsFetcher.close();
    _studentFetcher.close();
  }
}
