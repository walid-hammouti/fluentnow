part of 'likedcourses_cubit.dart';

@immutable
sealed class LikedcoursesState {}

final class LikedcoursesInitial extends LikedcoursesState {}

final class LikedcoursesLoading extends LikedcoursesState {}

final class LikedcoursesLoaded extends LikedcoursesState {
  final List<Course> likedcourses;

  LikedcoursesLoaded(this.likedcourses);
}

final class LikedcoursesError extends LikedcoursesState {
  final String message;

  LikedcoursesError(this.message);
}
