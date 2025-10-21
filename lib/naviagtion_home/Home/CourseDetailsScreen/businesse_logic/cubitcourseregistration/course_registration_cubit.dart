import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/model/courseregistration.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/repository/coursedetails_repo.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'course_registration_state.dart';

class CourseRegistrationCubit extends Cubit<CourseRegistrationState> {
  final String? userId = Supabase.instance.client.auth.currentUser?.id;

  final CoursedetailsRepo coursedetailsRepo;
  CourseRegistrationCubit(this.coursedetailsRepo)
    : super(CourseRegistrationInitial());

  Future<void> insertCourseRegistration(String courseId, String notes) async {
    if (userId == null) return;
    emit(CourseRegistrationLoading());
    try {
      final courseRegistration = CourseRegistration(
        userId: userId!,
        courseId: courseId,
        notes: notes,
      );
      await coursedetailsRepo.insertCourseRegistration(courseRegistration);
      emit(CourseRegistrationSuccess());
    } catch (e) {
      emit(CourseRegistrationError(e.toString()));
    }
  }
}
