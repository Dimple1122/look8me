import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/global_database_helper.dart';
import 'package:look8me/common/utils/utility.dart';

import '../../../../common/model/novel_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<NovelByCategory> homeComponents = [];
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadingEvent>(homeLoadingComponents);
  }

  FutureOr<void> homeLoadingComponents(HomeLoadingEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Utility.getAllData();
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
      homeComponents.insert(0, NovelByCategory(category: 'Top Picks For You', novels: recommendedNovels));
    }
  }
}