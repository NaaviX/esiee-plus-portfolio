

import 'package:bde_esiee_mobile/src/models/course_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CourseBloc {
  final _repository = Repository();

  final _coursesFetcher = PublishSubject<List<CourseModel>>();

  Observable<List<CourseModel>> get allCourses => _coursesFetcher.stream;

  fetchAllCourses(String ids) async {
    List<CourseModel> coursesModel = await _repository.fetchAllCourses(ids);
    _coursesFetcher.sink.add(coursesModel);
  }

  dispose() {
    _coursesFetcher.close();
  }
}