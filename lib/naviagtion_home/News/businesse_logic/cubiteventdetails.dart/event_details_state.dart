part of 'event_details_cubit.dart';

@immutable
sealed class EventDetailsState {}

final class EventDetailsInitial extends EventDetailsState {}

final class EventDetailsloading extends EventDetailsState {}

final class EventDetailsLoaded extends EventDetailsState {
  final SchoolEvent event;

  EventDetailsLoaded(this.event);
}

final class EventDetailsError extends EventDetailsState {
  final String message;

  EventDetailsError(this.message);
}
