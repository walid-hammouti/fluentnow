import 'package:supabase_flutter/supabase_flutter.dart';

class CourseslistWebsrevices {
  Future<List<Map<String, dynamic>>> fetchAllCourses() async {
    try {
      final allCourses =
          await Supabase.instance.client.from('courses').select();
      return allCourses;
    } catch (e) {
      throw Exception('Error fetching courses: ${e.toString()}');
    }
  }
}
