import 'package:fluentnow/naviagtion_home/Courses%20List/data/webservices/courseslist_websrevices.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';

class CourseslistRepo {
  final CourseslistWebsrevices courseslistWebsrevices;

  CourseslistRepo({required this.courseslistWebsrevices});

  Future<List<Course>> fetchAllCourses() async {
    try {
      final response = await courseslistWebsrevices.fetchAllCourses();

      // Assuming response is List<Map<String, dynamic>>
      return response.map((courseJson) => Course.fromJson(courseJson)).toList();
    } catch (e) {
      // Handle specific exceptions as needed
      throw Exception('Failed to fetch courses: $e');
    }
  }
}
