import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:fluentnow/naviagtion_home/Likes/data/webservices/likedcourses_webservices.dart';

class LikedcoursesRepo {
  final LikedcoursesWebservices likedcoursesWebservices;

  LikedcoursesRepo(this.likedcoursesWebservices);
  Future<List<Course>> fetchLikedCourses() async {
    final likedcourses = await likedcoursesWebservices.fetchLikedCourses();

    return likedcourses.map((course) => Course.fromJson(course)).toList();
  }
}
