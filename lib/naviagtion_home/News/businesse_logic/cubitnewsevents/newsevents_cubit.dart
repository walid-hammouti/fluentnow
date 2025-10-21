import 'package:bloc/bloc.dart';
import 'package:fluentnow/naviagtion_home/News/data/model/news&events.dart';
import 'package:fluentnow/naviagtion_home/News/data/repository/newsevents_repo.dart';
import 'package:meta/meta.dart';

part 'newsevents_state.dart';

class NewseventsCubit extends Cubit<NewseventsState> {
  final NewseventsRepo newseventsRepo;

  NewseventsCubit(this.newseventsRepo) : super(NewseventsInitial());

  void fetchAllNews() async {
    emit(Newsloading());
    try {
      final allNews = await newseventsRepo.fetchAllNews();
      emit(Newsloaded(allNews));
    } catch (e) {
      emit(NewsError('failed to fetch all news:${e.toString()}'));
    }
  }

  void fetchAllEvents() async {
    emit(Eventsloading());
    try {
      final allEvents = await newseventsRepo.fetchAllEvents();
      emit(Eventsloaded(allEvents));
    } catch (e) {
      emit(EventsError('failed to fetch all Events:${e.toString()}'));
    }
  }
}
