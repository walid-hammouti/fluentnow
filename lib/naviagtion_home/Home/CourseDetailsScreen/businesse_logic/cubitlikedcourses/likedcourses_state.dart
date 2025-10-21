part of 'likedcourses_cubit.dart';

@immutable
sealed class CourseLikeState {}

final class LikeInitial extends CourseLikeState {}

final class LikeLoading extends CourseLikeState {}

final class LikeSuccess extends CourseLikeState {}

final class UnlikeSuccess extends CourseLikeState {}

final class LikeError extends CourseLikeState {
  final String message;

  LikeError(this.message);
}
