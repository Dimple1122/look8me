

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/global_database_helper.dart';
import 'package:look8me/common/utils/utility.dart';

import '../../../../common/model/novel_model.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  List<Novel> updatedNovels = [];
  ExploreBloc() : super(ExploreInitial()) {
    on<ExploreLoadEvent>(loadAllNovels);
    on<SearchTextChangeEvent>(updateNovelList);
  }

  FutureOr<void> loadAllNovels(_, Emitter<ExploreState> emit) async {
    emit(ExploreLoadState());
    await Utility.getAllData();
    updatedNovels = GlobalDatabaseHelper.allNovels;
    emit(ExploreLoadedState());
  }

  FutureOr<void> updateNovelList(SearchTextChangeEvent event, Emitter<ExploreState> emit) {
    updatedNovels = GlobalDatabaseHelper.allNovels.where((element) => element.novelName!.toLowerCase().contains(event.text.toLowerCase())).toList();
    emit(SearchTextChanged(event.text));
  }
}
