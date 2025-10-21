import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/user.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/repository/home_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  Future<void> fetchHomeScreen() async {
    emit(HomeLoading());

    try {
      final results = await Future.wait([
        homeRepo.fetchCurrentUserProfile(),
        homeRepo.fetchNewestCourses(),
        homeRepo.fetchTopDiscountedCourses(),
      ]);

      emit(
        HomeLoaded(
          user: results[0] as User,
          newestCourses: results[1] as List<Course>,
          discountedCourses: results[2] as List<Course>,
        ),
      );
    } catch (e) {
      emit(HomeError('Failed to load home screen data: ${e.toString()}'));
    }
  }
}
