
import 'package:bde_esiee_mobile/src/models/student_model.dart';
import 'package:meta/meta.dart';
abstract class StudentEvent {
  const StudentEvent();
}

class StudentListRequested extends StudentEvent {

  const StudentListRequested();

}

class StudentRequested extends StudentEvent {

  final String email;
  const StudentRequested({@required this.email}) : assert(email != null);

}


class StudentToBeSaved extends StudentEvent {
  final StudentModel student;
  const StudentToBeSaved({@required this.student}) : assert(student != null);

}