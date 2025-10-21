import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/model/coursedetails.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/model/courseregistration.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/model/likedcourse.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/repository/coursedetails_repo.dart';

import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'coursedetails_state.dart';

class CoursedetailsCubit extends Cubit<CourseDetailsState> {
  final CoursedetailsRepo coursedetailsRepo;
  final String? userId = Supabase.instance.client.auth.currentUser?.id;

  CoursedetailsCubit(this.coursedetailsRepo) : super(CourseDetailsInitial());

  Future<void> getCourseDetailsScreen(String courseId) async {
    if (userId == null) return;

    emit(CourseDetailsLoading());
    try {
      final likedcourse = Likedcourse(courseId: courseId, userId: userId!);
      final courseregistration = CourseRegistration(
        userId: userId!,
        courseId: courseId,
      );
      final results = await Future.wait([
        coursedetailsRepo.getCourseLiked(likedcourse),
        coursedetailsRepo.getCourseDetails(courseId),
        coursedetailsRepo.getregistration(courseregistration),
      ]);
      emit(
        CourseDetailsLoaded(
          isliked: results[0] as bool,
          details: results[1] as Coursedetails,
          isregistred: results[2] as bool,
        ),
      );
    } catch (e) {
      emit(CourseDetailsError(e.toString()));
    }
  }
}
