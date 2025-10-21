import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/model/likedcourse.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/repository/coursedetails_repo.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'likedcourses_state.dart';

class CourseLikeCubit extends Cubit<CourseLikeState> {
  final CoursedetailsRepo coursedetailsRepo;
  final String? userId = Supabase.instance.client.auth.currentUser?.id;

  CourseLikeCubit(this.coursedetailsRepo) : super(LikeInitial());

  Future<void> toggleLike(String courseId, bool currentStatus) async {
    if (userId == null) return;

    emit(LikeLoading());
    try {
      final likedcourse = Likedcourse(courseId: courseId, userId: userId!);
      if (currentStatus) {
        await coursedetailsRepo.courseUnliked(likedcourse);
        emit(UnlikeSuccess());
      } else {
        await coursedetailsRepo.courseLiked(likedcourse);
        emit(LikeSuccess());
      }
    } catch (e) {
      emit(LikeError(e.toString()));
      rethrow;
    }
  }
}
