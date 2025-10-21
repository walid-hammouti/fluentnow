part of 'course_registration_cubit.dart';

@immutable
sealed class CourseRegistrationState {}

final class CourseRegistrationInitial extends CourseRegistrationState {}

final class CourseRegistrationLoading extends CourseRegistrationState {}

final class CourseRegistrationSuccess extends CourseRegistrationState {}

final class CourseRegistrationError extends CourseRegistrationState {
  final String message;

  CourseRegistrationError(this.message);
}
