import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionWebservices {
  Future<List<Map<String, dynamic>>> fetchSubscribedCourses() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Fetch both course_id and status from course_registrations
      final subscriptionCourses = await Supabase.instance.client
          .from('course_registrations')
          .select('course_id, status')
          .eq('user_id', userId);

      if (subscriptionCourses.isEmpty) return [];

      // Extract course IDs for the second query
      final coursesIds =
          subscriptionCourses
              .map((course) => course['course_id'] as String)
              .toList();

      // Fetch course details
      final coursesResponse = await Supabase.instance.client
          .from('courses')
          .select('''
          id,
          title,
          price,
          discounted_price,
          start_date
        ''')
          .inFilter('id', coursesIds);

      // Convert to List<Map> if not already
      final coursesData = List<Map<String, dynamic>>.from(coursesResponse);

      // Combine course data with status from registrations
      final result =
          coursesData.map((course) {
            // Find the corresponding registration to get the status
            final registration = subscriptionCourses.firstWhere(
              (reg) => reg['course_id'] == course['id'],
              orElse: () => {'status': 'unknown'},
            );

            return {...course, 'status': registration['status']};
          }).toList();

      return result;
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
