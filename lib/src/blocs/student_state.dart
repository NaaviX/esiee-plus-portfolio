import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:meta/meta.dart';
import 'package:bde_esiee_mobile/src/models/stock_model.dart';

abstract class StudentState  {
  const StudentState();

}

class StudentInitial extends StudentState {}

class StudentListInitial extends StudentState {}

class StudentLoadInProgress extends StudentState {}

class StudentListLoadInProgress extends StudentState {}

class StudentListLoadSuccess extends StudentState {
  final List<StudentModel> students;

  const StudentListLoadSuccess({@required this.students}) : assert(students != null);

}

class StudentSaveLoadSuccess extends StudentState {
  final StudentModel student;

  const StudentSaveLoadSuccess({@required this.student}) : assert(student != null);

}

class StudentLoadSuccess extends StudentState {
  final StudentModel student;

  const StudentLoadSuccess({@required this.student}) : assert(student != null);

}

class StudentListLoadFailure extends StudentState {}
class StudentLoadFailure extends StudentState {}

class StudentSaveLoadFailure extends StudentState {}

