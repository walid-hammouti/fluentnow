part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final User user;
  final List<Course> newestCourses;
  final List<Course> discountedCourses;

  HomeLoaded({
    required this.user,
    required this.newestCourses,
    required this.discountedCourses,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeLoaded &&
        other.user == user &&
        listEquals(other.newestCourses, newestCourses) &&
        listEquals(other.discountedCourses, discountedCourses);
  }

  @override
  int get hashCode =>
      user.hashCode ^ newestCourses.hashCode ^ discountedCourses.hashCode;
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
