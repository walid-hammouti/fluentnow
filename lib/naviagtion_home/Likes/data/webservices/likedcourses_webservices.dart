import 'package:supabase_flutter/supabase_flutter.dart';

class LikedcoursesWebservices {
  Future<List<Map<String, dynamic>>> fetchLikedCourses() async {
    final supabase = Supabase.instance.client;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No logged-in user');

      // Step 1: Get liked course IDs
      final likedResponse = await supabase
          .from('liked_courses')
          .select('course_id')
          .eq('user_id', user.id);

      if (likedResponse.isEmpty) return [];

      final courseIds = likedResponse.map((item) => item['course_id']).toList();

      // Step 2: Fetch the course details using inFilter
      final coursesResponse = await supabase
          .from('courses')
          .select('*')
          .inFilter('id', courseIds);

      return List<Map<String, dynamic>>.from(coursesResponse);
    } catch (e) {
      throw Exception('Error fetching liked courses: ${e.toString()}');
    }
  }
}
