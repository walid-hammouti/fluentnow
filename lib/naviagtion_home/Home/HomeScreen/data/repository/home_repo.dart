import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/user.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/webservices/home_webservices.dart';

class HomeRepo {
  final HomeWebservices homeWebservices;
  HomeRepo(this.homeWebservices);

  Future<User> fetchCurrentUserProfile() async {
    try {
      final userMap = await homeWebservices.fetchCurrentUserProfile();
      return User.fromJson(userMap);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<List<Course>> fetchNewestCourses() async {
    try {
      final newestcourses = await homeWebservices.fetchNewestCourses();
      return newestcourses.map((course) => Course.fromJson(course)).toList();
    } catch (e) {
      throw Exception('Failed to fetch newest courses: $e');
    }
  }

  Future<List<Course>> fetchTopDiscountedCourses() async {
    try {
      final topDiscountedCourses =
          await homeWebservices.fetchTopDiscountedCourses();
      return topDiscountedCourses
          .map((course) => Course.fromJson(course))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch top discounted courses: $e');
    }
  }
}
