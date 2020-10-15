import 'package:bde_esiee_mobile/src/blocs/student_event.dart';
import 'package:bde_esiee_mobile/src/blocs/student_state.dart';
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:bde_esiee_mobile/src/resources/student_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

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
        final List<StudentModel> students = await studentRepository
            .fetchStudents();
        yield StudentListLoadSuccess(students: students);
      } catch (_) {
        yield StudentListLoadFailure();
      }
    }

    else if (event is StudentRequested) {
      yield StudentLoadInProgress();
      try {
        final StudentModel student = await studentRepository.fetchStudent(
            event.email);
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
}