

import 'package:bde_esiee_mobile/src/models/course_model.dart';
import 'package:bde_esiee_mobile/src/resources/Calendar/courses_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'course_event.dart';
import 'course_state.dart';

import 'package:meta/meta.dart';

class CoursesBloc extends Bloc<CourseEvent, CourseState> {
  final CoursesRepository coursesRepository;

  CoursesBloc({@required this.coursesRepository})
      : assert(coursesRepository != null),
        super(CoursesInitial());

  @override
  Stream<CourseState> mapEventToState(CourseEvent event) async* {

    if (event is CoursesRequested) {
      yield CoursesLoadInProgress();
      try {
        final List<CourseModel> courses = await coursesRepository.fetchCourses();
        yield CoursesLoadSuccess(courses: courses);
      } catch (_) {
        yield CoursesLoadFailure();
      }
    }
  }
}