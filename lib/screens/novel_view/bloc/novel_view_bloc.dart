import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:look8me/common/services/firebase/firebase_storage_service.dart';
import 'package:look8me/common/services/locator.dart';

import '../../../common/model/novel_model.dart';

part 'novel_view_event.dart';
part 'novel_view_state.dart';

class NovelViewBloc extends Bloc<NovelViewEvent, NovelViewState> {
  final Novel novel;
  double readProgress = 0.0;
  NovelViewBloc({required this.novel, required this.readProgress}) : super(NovelViewInitial()) {
    // on<NovelViewEvent>((event, emit) {});
    on<NovelViewInitializationEvent>(getNovelContent);
    on<UpdatePageAndReadProgressEvent>((event, emit) {readProgress = event.readProgress; emit(UpdatedPageAndReadProgressState(page: event.page));});
  }

  FutureOr<void> getNovelContent(NovelViewInitializationEvent event, Emitter<NovelViewState> emit) async {
    emit(NovelViewLoadingState());
    Uint8List? data;
    try{
      data = await locator.get<FirebaseStorageService>().getData(novel.novelContent!);
      emit(NovelViewLoadedState(novelData: data));
    }
    catch(e) {
      emit(NovelViewLoadFailedState());
      debugPrint(e.toString());
    }
  }

}
