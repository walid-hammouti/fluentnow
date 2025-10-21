import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/Subscription/data/model/subscriptioncourses.dart';
import 'package:fluentnow/naviagtion_home/Subscription/data/repository/subscription_repo.dart';
import 'package:flutter/material.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepo subscriptionRepo;
  SubscriptionCubit(this.subscriptionRepo) : super(SubscriptionInitial());

  void fetchSubscibedCourses() async {
    emit(SubscriptionLoading());
    try {
      final subcourses = await subscriptionRepo.fetchSubscibedCourses();
      emit(SubscriptionLoaded(subcourses));
    } catch (e) {
      emit(SubscriptionErrore(e.toString()));
    }
  }
}
