import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/global_database_helper.dart';
import 'package:look8me/common/utils/app_strings.dart';
import 'package:look8me/common/utils/utility.dart';

import '../../../../common/model/novel_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<NovelByCategory> homeComponents = [];
  List<NovelWithReadProgress> continueReadingNovels = [];
  late final StreamSubscription<DatabaseEvent> continueReadingSubscription;
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadingEvent>(homeLoadingComponents);
    on<GetUpdatedContinueReadingNovelsEvent>(getUpdatedContinueReadingNovels);
  }

  FutureOr<void> homeLoadingComponents(HomeLoadingEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Utility.getAllData();
    continueReadingNovels = await calculateContinueReadingNovels();
    for (var category in GlobalDatabaseHelper.allCategories) {
      final novelsByCategory = GlobalDatabaseHelper.allNovels.where((novel) => novel.novelCategory == category).toList();
      homeComponents.add(NovelByCategory(category: category, novels: novelsByCategory));
    }
    getRecommendedNovels();
    emit(HomeLoadedState());
  }

  void getRecommendedNovels() {
    final categoriesSelectedByUser = GlobalDatabaseHelper.currentUser?.categoriesSelected;
    const noOfItemsFactor = 15;
    final List<Novel> recommendedNovels = [];
    if(categoriesSelectedByUser != null) {
      final eachCategoryNovelLimit = noOfItemsFactor~/categoriesSelectedByUser.length;
      for(String category in categoriesSelectedByUser) {
        final novels = homeComponents.where((element) => element.category == category).toList().elementAt(0).novels;
        novels.sort((a, b) => a.noOfLikes!.compareTo(b.noOfLikes!));
        for(int i = 0; i < novels.length; i++) {
          if(recommendedNovels.length <= noOfItemsFactor && i <= eachCategoryNovelLimit) {
            recommendedNovels.add(novels.elementAt(i));
           continue; 
          }
          break;
        }
      }
      recommendedNovels.shuffle();
      homeComponents.insert(0, NovelByCategory(category: AppStrings.topPicks, novels: recommendedNovels));
    }
  }

  FutureOr<void> getUpdatedContinueReadingNovels(_, Emitter<HomeState> emit) async {
    emit(HomeInitial());
    continueReadingNovels = await calculateContinueReadingNovels();
    emit(ContinueReadingNovelsUpdatedState());
  }

  FutureOr<List<NovelWithReadProgress>> calculateContinueReadingNovels() {
    return GlobalDatabaseHelper.getAllContinueReadingNovels().map((novel) => NovelWithReadProgress(novel: novel, readProgress: GlobalDatabaseHelper.getNovelReadProgress(novel.novelId!))).toList();
  }

  @override
  Future<void> close() {
    continueReadingSubscription.cancel();
    return super.close();
  }
}