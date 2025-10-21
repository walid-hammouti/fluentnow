import 'package:supabase_flutter/supabase_flutter.dart';

class CoursedetailsWebserivces {
  Future<Map<String, dynamic>> getCourseDetails(String courseId) async {
    try {
      final response =
          await Supabase.instance.client
              .from('courses')
              .select('''
          description,
          level,
          language,
          start_date,
          end_date,
          teacher_id
        ''')
              .eq('id', courseId)
              .single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch course details: $e');
    }
  }

  Future<bool> getCourseLiked(Map<String, dynamic> courseLiked) async {
    try {
      final response = await Supabase.instance.client
          .from('liked_courses')
          .select()
          .eq('user_id', courseLiked['user_id'])
          .eq('course_id', courseLiked['course_id']);

      return response.isNotEmpty; // Returns true if the course is liked
    } catch (e) {
      throw Exception('Cannot fetch liked status: ${e.toString()}');
    }
  }

  Future<bool> getregistration(Map<String, dynamic> courseRegistration) async {
    try {
      final response = await Supabase.instance.client
          .from('course_registrations')
          .select()
          .eq('user_id', courseRegistration['user_id'])
          .eq('course_id', courseRegistration['course_id']);

      return response.isNotEmpty; // Returns true if the course is liked
    } catch (e) {
      throw Exception('Cannot fetch liked status: ${e.toString()}');
    }
  }

  Future<void> courseLiked(Map<String, dynamic> likedCourses) async {
    try {
      await Supabase.instance.client.from('liked_courses').insert(likedCourses);
    } catch (e) {
      throw Exception('Failed to like course: $e');
    }
  }

  Future<void> courseUnliked(Map<String, dynamic> courseUnliked) async {
    try {
      await Supabase.instance.client
          .from('liked_courses')
          .delete()
          .eq('user_id', courseUnliked['user_id'])
          .eq('course_id', courseUnliked['course_id']);
    } catch (e) {
      throw Exception('Failed to unlike course: $e');
    }
  }

  Future<void> insertCourseRegistration(
    Map<String, dynamic> courseRegistration,
  ) async {
    try {
      await Supabase.instance.client.from('course_registrations').insert({
        'user_id': courseRegistration['user_id'],
        'course_id': courseRegistration['course_id'],
        'notes': courseRegistration['notes'],
      });
    } catch (e) {
      throw Exception('Failed to insert course registration: $e');
    }
  }
}
