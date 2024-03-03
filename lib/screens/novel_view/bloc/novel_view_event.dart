part of 'novel_view_bloc.dart';

abstract class NovelViewEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class NovelViewInitializationEvent extends NovelViewEvent {
  final String novelContent;
  NovelViewInitializationEvent({required this.novelContent});
}

class UpdatePageAndReadProgressEvent extends NovelViewEvent {
  final int page;
  UpdatePageAndReadProgressEvent({required this.page});

  @override
  List<Object> get props => [page];
}