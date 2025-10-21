import 'package:fluentnow/naviagtion_home/Subscription/data/model/subscriptioncourses.dart';
import 'package:fluentnow/naviagtion_home/Subscription/data/webservices/subscription_webservices.dart';

class SubscriptionRepo {
  final SubscriptionWebservices subscriptionWebservices;

  SubscriptionRepo(this.subscriptionWebservices);

  Future<List<Subscriptioncourses>> fetchSubscibedCourses() async {
    try {
      final allCourses = await subscriptionWebservices.fetchSubscribedCourses();
      if (allCourses.isEmpty) return [];

      return allCourses
          .map((course) => Subscriptioncourses.fromJson(course))
          .toList();
    } catch (e) {
      throw Exception('Failed to parse courses: ${e.toString()}');
    }
  }
}
