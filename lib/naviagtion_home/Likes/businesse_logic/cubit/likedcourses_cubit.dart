import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:fluentnow/naviagtion_home/Likes/data/repository/likedcourses_repo.dart';
import 'package:meta/meta.dart';

part 'likedcourses_state.dart';

class LikedcoursesCubit extends Cubit<LikedcoursesState> {
  final LikedcoursesRepo likedcoursesRepo;
  LikedcoursesCubit(this.likedcoursesRepo) : super(LikedcoursesInitial());

  Future<void> fetchLikedCourses() async {
    emit(LikedcoursesLoading());
    try {
      final likedcourses = await likedcoursesRepo.fetchLikedCourses();
      emit(LikedcoursesLoaded(likedcourses));
    } catch (e) {
      emit(LikedcoursesError(e.toString()));
    }
  }
}
