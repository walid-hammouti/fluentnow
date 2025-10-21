import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/model/coursedetails.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/model/courseregistration.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/model/likedcourse.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/webservices/coursedetails_webserivces.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoursedetailsRepo {
  final CoursedetailsWebserivces coursedetailsWebserivces;
  CoursedetailsRepo(this.coursedetailsWebserivces);

  Future<Coursedetails> getCourseDetails(String courseId) async {
    try {
      final coursedetails = await coursedetailsWebserivces.getCourseDetails(
        courseId,
      );
      return Coursedetails.fromjson(coursedetails);
    } catch (e) {
      throw Exception('Failed to fetch course details: $e');
    }
  }

  Future<bool> getCourseLiked(Likedcourse course) async {
    try {
      return await coursedetailsWebserivces.getCourseLiked(course.toJson());
    } catch (e) {
      throw Exception('Failed to check if course is liked: $e');
    }
  }

  Future<bool> getregistration(CourseRegistration course) async {
    try {
      return await coursedetailsWebserivces.getregistration(course.toJson());
    } catch (e) {
      throw Exception('Failed to check if course is liked: $e');
    }
  }

  Future<void> courseLiked(Likedcourse course) async {
    try {
      await coursedetailsWebserivces.courseLiked(course.toJson());
    } catch (e) {
      throw Exception('Failed to like course: $e');
    }
  }

  Future<void> courseUnliked(Likedcourse course) async {
    try {
      await coursedetailsWebserivces.courseUnliked(course.toJson());
    } catch (e) {
      throw Exception('Failed to like course: $e');
    }
  }

  Future<void> insertCourseRegistration(
    CourseRegistration courseRegistration,
  ) async {
    try {
      await coursedetailsWebserivces.insertCourseRegistration(
        courseRegistration.toJson(),
      );
    } catch (e) {
      throw 'Failed to register course: ${e.toString()}';
    }
  }
}
