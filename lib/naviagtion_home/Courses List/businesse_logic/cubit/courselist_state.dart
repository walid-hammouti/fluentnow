part of 'courselist_cubit.dart';

@immutable
sealed class CourselistState {}

final class CourselistInitial extends CourselistState {}

final class CourselistLoading extends CourselistState {}

final class CourselistLoaded extends CourselistState {
  final List<Course> courselist;
  CourselistLoaded({required this.courselist});
}

final class CourselistError extends CourselistState {
  final String message;
  CourselistError({required this.message});
}
