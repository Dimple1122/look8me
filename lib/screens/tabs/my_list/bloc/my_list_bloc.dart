import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/global_database_helper.dart';
import 'package:look8me/common/utils/utility.dart';

import '../../../../common/model/novel_model.dart';

part 'my_list_event.dart';
part 'my_list_state.dart';

class MyListBloc extends Bloc<MyListEvent, MyListState> {
  List<Novel> myList = [];
  MyListBloc() : super(MyListInitial()) {
    on<LoadMyListEvent>(loadMyList);
    on<RemoveNovelFromMyListEvent>(removeNovelFromMyList);
  }

  FutureOr<void> loadMyList(LoadMyListEvent event, Emitter<MyListState> emit) async {
    emit(MyListLoadingState());
    await Utility.getAllData();
    myList = GlobalDatabaseHelper.getMyListNovels();
    emit(MyListLoadedState());
  }

  FutureOr<void> removeNovelFromMyList(RemoveNovelFromMyListEvent event, Emitter<MyListState> emit) async {
    GlobalDatabaseHelper.removeNovelFromMyList(event.novelId);
    myList.removeWhere((element) => element.novelId == event.novelId);
    emit(NovelRemovedFromMyListState(event.novelId));
  }
}
