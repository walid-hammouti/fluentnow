part of 'coursedetails_cubit.dart';

@immutable
sealed class CourseDetailsState {}

final class CourseDetailsInitial extends CourseDetailsState {}

final class CourseDetailsLoading extends CourseDetailsState {}

final class CourseDetailsLoaded extends CourseDetailsState {
  final Coursedetails details;
  final bool isliked;
  final bool isregistred;
  CourseDetailsLoaded({
    required this.isregistred,
    required this.isliked,
    required this.details,
  });
}

final class CourseDetailsError extends CourseDetailsState {
  final String message;

  CourseDetailsError(this.message);
}
