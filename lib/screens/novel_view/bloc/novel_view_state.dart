part of 'novel_view_bloc.dart';

abstract class NovelViewState extends Equatable{

  @override
  List<Object> get props => [];
}

class NovelViewInitial extends NovelViewState {}

class NovelViewLoadingState extends NovelViewState {}

class NovelViewLoadedState extends NovelViewState {
  final Uint8List? novelData;
  NovelViewLoadedState({required this.novelData});
}

class NovelViewLoadFailedState extends NovelViewState {}

class UpdatedPageAndReadProgressState extends NovelViewState {
  final int page;

  UpdatedPageAndReadProgressState({required this.page});

  @override
  List<Object> get props => [page];
}
