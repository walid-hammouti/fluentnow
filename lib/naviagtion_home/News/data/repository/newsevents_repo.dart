import 'package:fluentnow/naviagtion_home/News/data/model/news&events.dart';
import 'package:fluentnow/naviagtion_home/News/data/webservices/newsevents_webserviecs.dart';

class NewseventsRepo {
  final NewseventsWebserviecs newseventsWebserviecs;

  NewseventsRepo(this.newseventsWebserviecs);
  Future<List<News>> fetchAllNews() async {
    final allNews = await newseventsWebserviecs.fetchAllNews();

    return allNews.map((news) => News.fromJson(news)).toList();
  }

  Future<List<Eventcard>> fetchAllEvents() async {
    final allEvents = await newseventsWebserviecs.fetchAllEvents();

    return allEvents.map((news) => Eventcard.fromJson(news)).toList();
  }

  Future<SchoolEvent> fetchEventDetails(String eventId) async {
    final eventDetails = await newseventsWebserviecs.fetchEventDetails(eventId);
    return SchoolEvent.fromJson(eventDetails);
  }
}
