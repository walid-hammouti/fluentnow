import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/News/data/model/news&events.dart';
import 'package:fluentnow/naviagtion_home/News/data/repository/newsevents_repo.dart';
import 'package:meta/meta.dart';

part 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final NewseventsRepo newseventsRepo;
  EventDetailsCubit(this.newseventsRepo) : super(EventDetailsInitial());

  void fetchEventDetails(String eventId) async {
    emit(EventDetailsloading());
    try {
      final eventDetails = await newseventsRepo.fetchEventDetails(eventId);
      emit(EventDetailsLoaded(eventDetails));
    } catch (e) {
      emit(EventDetailsError(e.toString()));
    }
  }
}
