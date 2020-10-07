import 'package:bde_esiee_mobile/src/blocs/student_event.dart';
import 'package:bde_esiee_mobile/src/blocs/student_state.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/resources/repository.dart';
import 'package:bde_esiee_mobile/src/resources/student_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class StudentsBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;

  StudentsBloc({@required this.studentRepository})
      : assert(studentRepository != null),
        super(StudentInitial());

  @override
  Stream<StudentState> mapEventToState(StudentEvent event) async* {
    if (event is StudentListRequested) {
      yield StudentListLoadInProgress();
      try {
        final List<StudentModel> students = await studentRepository.fetchStudents();
        yield StudentListLoadSuccess(students: students);
      } catch (_) {
        yield StudentListLoadFailure();
      }
    }

    else if (event is StudentRequested) {
      yield StudentLoadInProgress();
      try {
        final StudentModel student = await studentRepository.fetchStudent(event.email);
        yield StudentLoadSuccess(student: student);
      } catch (_) {
        yield StudentLoadFailure();
      }
    }

    else if (event is StudentToBeSaved) {
      try {
        await studentRepository.saveStudent(event.student);
      } catch (_) {
        yield StudentSaveLoadFailure();
      }
    }
  }
  /*fetchAllStudentClubs(StudentModel student) async {
    List<ClubModel> studentClubs=await _repository.fetchAllClubs();
    studentClubs.removeWhere((element) => !element.students.contains(student));
    _studentsClubFetcher.sink.add(studentClubs);
  }*/

}
class StudentsBlocOld {
final _repository = Repository();
final _studentsFetcher = PublishSubject<List<StudentModel>>();
final _studentFetcher = PublishSubject<StudentModel>();

Observable<List<StudentModel>> get allStudents => _studentsFetcher.stream;
Observable<StudentModel> get thisStudent => _studentFetcher.stream;

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

dispose() {
  _studentsFetcher.close();
  _studentFetcher.close();
}
}