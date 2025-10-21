import 'package:supabase_flutter/supabase_flutter.dart';

class HomeWebservices {
  Future<Map<String, dynamic>> fetchCurrentUserProfile() async {
    final supabase = Supabase.instance.client;

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Fetch basic user info from 'users' table
      final userResponse =
          await supabase
              .from('users')
              .select('id, username')
              .eq('id', user.id)
              .single();

      // Fetch avatar from 'user_details' table
      final detailsResponse =
          await supabase
              .from('user_details')
              .select('avatar_url')
              .eq('user_id', user.id)
              .maybeSingle(); // Use maybeSingle in case record doesn't exist

      return {
        'id': userResponse['id'] as String,
        'username': userResponse['username'] as String,
        'avatar_url': detailsResponse?['avatar_url'] as String?, // Can be null
      };
    } catch (error) {
      throw Exception('Failed to fetch user profile: $error');
    }
  }

  /// Fetches the 4 most recently created active courses from Supabase.
  //
  /// Returns a list of course maps ordered by creation date (newest first).
  /// Throws an exception if the query fails.
  ///
  Future<List<Map<String, dynamic>>> fetchNewestCourses() async {
    final supabase = Supabase.instance.client;

    try {
      final courses = await supabase
          .from('courses')
          .select('''
          id,
          title,
          hours_per_week,
          max_students,
          duration_weeks,
          price,
          image_url
        ''')
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(4);

      return courses;
    } catch (error) {
      throw Exception('Error fetching courses: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTopDiscountedCourses() async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('courses')
          .select('''
          id,
          title,
          hours_per_week,
          max_students,
          duration_weeks,
          price,
          discount_percent,
          discounted_price,
          discount_expiry,
          image_url,
          end_date
        ''')
          .order('discount_percent', ascending: false)
          .limit(4);

      return response;
    } catch (error) {
      throw Exception('Error fetching courses: $error');
    }
  }
}
