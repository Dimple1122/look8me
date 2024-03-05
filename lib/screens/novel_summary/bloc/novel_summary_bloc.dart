import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/firebase/firebase_storage_service.dart';
import 'package:look8me/common/services/global_database_helper.dart';
import 'package:look8me/common/services/locator.dart';

import '../../../common/model/novel_model.dart';

part 'novel_summary_event.dart';

part 'novel_summary_state.dart';

class NovelSummaryBloc extends Bloc<NovelSummaryEvent, NovelSummaryState> {
  final Novel novel;
  String summaryText = '';
  bool isLiked = false;
  bool isAddedToMyList = false;
  double readProgress = 0.0;
  int noOfLikes = 0;
  bool isFullSummary = false;
  late final int novelIndex;
  late final StreamSubscription<DatabaseEvent> noOfLikesSubscription;

  NovelSummaryBloc({required this.novel}) : super(NovelSummaryInitial()) {
    on<NovelSummaryLoadingEvent>(loadNovelSummary);
    on<NovelSummaryTextTapEvent>((event, emit) {
      isFullSummary = !isFullSummary;
      emit(NovelSummaryTextTapState(isFullSummary));
    });
    on<NovelReadProgressUpdatedEvent>(updateReadProgress);
    on<NovelLikeUpdateEvent>(likeUpdateNovel);
    on<NovelNoOfLikesUpdateEvent>((_, emit) => emit(NovelNoOfLikesUpdateState(noOfLikes)));
    on<NovelAddToListUpdateEvent>(myListUpdateNovel);
  }

  FutureOr<void> loadNovelSummary(_, Emitter<NovelSummaryState> emit) async {
    emit(NovelSummaryLoadingState());
    final summaryData = await locator
        .get<FirebaseStorageService>()
        .getData(novel.novelSummary!);
    if (summaryData != null) {
      summaryText = String.fromCharCodes(summaryData);
    }
    novelIndex = GlobalDatabaseHelper.allNovels
        .indexWhere((element) => element.novelId == novel.novelId);
    noOfLikes = novel.noOfLikes!;
    isLiked = GlobalDatabaseHelper.isNovelLiked(novel.novelId!);
    readProgress = GlobalDatabaseHelper.getNovelReadProgress(novel.novelId!);
    isAddedToMyList = GlobalDatabaseHelper.isNovelInMyList(novel.novelId!);
    emit(NovelSummaryLoadedState());
  }

  FutureOr<void> updateReadProgress(
      NovelReadProgressUpdatedEvent event, Emitter<NovelSummaryState> emit) {
    readProgress = event.readProgress;
    emit(NovelReadProgressUpdateState(event.readProgress));
  }

  @override
  Future<void> close() {
    noOfLikesSubscription.cancel();
    return super.close();
  }

  FutureOr<void> likeUpdateNovel(NovelLikeUpdateEvent event, Emitter<NovelSummaryState> emit) {
    isLiked = !isLiked;
    emit(NovelLikeUpdateState(isLiked));
    if(isLiked) {
      noOfLikes = noOfLikes + 1;
      GlobalDatabaseHelper.likeNovel(novel.novelId!, novelIndex);
    }
    else {
      noOfLikes = noOfLikes - 1;
      GlobalDatabaseHelper.unLikeNovel(novel.novelId!, novelIndex);
    }
  }

  FutureOr<void> myListUpdateNovel(_, Emitter<NovelSummaryState> emit) {
    isAddedToMyList = !isAddedToMyList;
    emit(NovelAddToMyListUpdateState(isAddedToMyList));
    if(isAddedToMyList) {
      GlobalDatabaseHelper.addNovelToMyList(novel.novelId!);
    }
    else {
      GlobalDatabaseHelper.removeNovelFromMyList(novel.novelId!);
    }
  }
}
