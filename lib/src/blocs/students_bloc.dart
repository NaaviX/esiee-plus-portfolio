import 'package:bde_esiee_mobile/src/models/club_model.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class StudentsBloc {
  final _repository = Repository();
  final _studentsFetcher = PublishSubject<List<StudentModel>>();
  final _studentFetcher = PublishSubject<StudentModel>();

  Observable<List<StudentModel>> get allStudents => _studentsFetcher.stream;
  Observable<StudentModel> get thisStudent => _studentFetcher.stream;

  fetchAllStudents() async {
    List<StudentModel> studentmodel = await _repository.fetchAllStudents();
    _studentsFetcher.sink.add(studentmodel);
  }

  fetchStudent(String email) async {
    StudentModel studentModel = await _repository.fetchStudent(email);
    _studentFetcher.sink.add(studentModel);
  }

  updateStudent(StudentModel student) async {
    await _repository.updateStudent(student);
  }



  dispose() {
    _studentsFetcher.close();
    _studentFetcher.close();
  }
}
