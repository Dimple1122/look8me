part of 'novel_summary_bloc.dart';

abstract class NovelSummaryEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class NovelSummaryLoadingEvent extends NovelSummaryEvent {}

class NovelSummaryTextTapEvent extends NovelSummaryEvent {}

class NovelReadProgressUpdatedEvent extends NovelSummaryEvent {
  final double readProgress;
  NovelReadProgressUpdatedEvent(this.readProgress);
}

class NovelLikeUpdateEvent extends NovelSummaryEvent {}

class NovelNoOfLikesUpdateEvent extends NovelSummaryEvent {}

class NovelAddToListUpdateEvent extends NovelSummaryEvent {}