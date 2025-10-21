import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/data/repository/courseslist_repo.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:meta/meta.dart';

part 'courselist_state.dart';

class CourselistCubit extends Cubit<CourselistState> {
  final CourseslistRepo courseslistRepo;
  CourselistCubit(this.courseslistRepo) : super(CourselistInitial());

  Future<void> fetchAllCourses() async {
    emit(CourselistLoading());
    try {
      final courselist = await courseslistRepo.fetchAllCourses();
      emit(CourselistLoaded(courselist: courselist));
    } catch (e) {
      emit(CourselistError(message: e.toString()));
    }
  }
}
