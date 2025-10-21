part of 'subscription_cubit.dart';

@immutable
sealed class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}

final class SubscriptionLoading extends SubscriptionState {}

final class SubscriptionLoaded extends SubscriptionState {
  final List<Subscriptioncourses> subcourses;

  SubscriptionLoaded(this.subcourses);
}

final class SubscriptionErrore extends SubscriptionState {
  final String message;

  SubscriptionErrore(this.message);
}
