part of 'novel_summary_bloc.dart';

abstract class NovelSummaryState extends Equatable {

  @override
  List<Object> get props => [];
}

class NovelSummaryInitial extends NovelSummaryState {}

class NovelSummaryLoadingState extends NovelSummaryState {}

class NovelSummaryLoadedState extends NovelSummaryState {}

class UserActionProcessState extends NovelSummaryState {}

class NovelSummaryTextTapState extends NovelSummaryState {
  final bool isFullSummary;
  NovelSummaryTextTapState(this.isFullSummary);

  @override
  List<Object> get props => [isFullSummary];
}

class NovelReadProgressUpdateState extends NovelSummaryState {
  final double readProgress;
  NovelReadProgressUpdateState(this.readProgress);

  @override
  List<Object> get props => [readProgress];
}

class NovelLikeUpdateState extends NovelSummaryState {
  final bool isLiked;
  NovelLikeUpdateState(this.isLiked);

  @override
  List<Object> get props => [isLiked];
}

class NovelNoOfLikesUpdateState extends NovelSummaryState {
  final int noOfLikes;
  NovelNoOfLikesUpdateState(this.noOfLikes);

  @override
  List<Object> get props => [noOfLikes];
}

class NovelAddToMyListUpdateState extends NovelSummaryState {
  final bool isAddedToMyList;
  NovelAddToMyListUpdateState(this.isAddedToMyList);

  @override
  List<Object> get props => [isAddedToMyList];
}