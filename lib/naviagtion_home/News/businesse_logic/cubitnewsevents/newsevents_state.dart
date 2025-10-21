part of 'newsevents_cubit.dart';

@immutable
sealed class NewseventsState {}

final class NewseventsInitial extends NewseventsState {}

final class Newsloading extends NewseventsState {}

final class Newsloaded extends NewseventsState {
  final List<News> allNews;
  Newsloaded(this.allNews);
}

final class NewsError extends NewseventsState {
  final String message;

  NewsError(this.message);
}

final class Eventsloading extends NewseventsState {}

final class Eventsloaded extends NewseventsState {
  final List<Eventcard> allEvents;
  Eventsloaded(this.allEvents);
}

final class EventsError extends NewseventsState {
  final String message;

  EventsError(this.message);
}
