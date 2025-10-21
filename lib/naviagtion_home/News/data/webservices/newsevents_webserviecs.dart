import 'package:supabase_flutter/supabase_flutter.dart';

class NewseventsWebserviecs {
  Future<List<Map<String, dynamic>>> fetchAllNews() async {
    try {
      final response = await Supabase.instance.client
          .from('news')
          .select('''
          id,
          title,
          content,
          image_url,
          is_urgent,
          published_at,
          external_link,
          is_published
        ''')
          .order('published_at', ascending: false);
      return response;
    } catch (e) {
      throw Exception('Error fetching news: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllEvents() async {
    try {
      final response = await Supabase.instance.client.from('events').select('''
          id,
          title,
          description,
          image_url
        ''');
      return response;
    } catch (e) {
      throw Exception('Error fetching events: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> fetchEventDetails(String eventId) async {
    try {
      final response =
          await Supabase.instance.client
              .from('events')
              .select()
              .eq('id', eventId)
              .single();
      return response;
    } catch (e) {
      throw Exception('Error fetching event details: ${e.toString()}');
    }
  }
}
