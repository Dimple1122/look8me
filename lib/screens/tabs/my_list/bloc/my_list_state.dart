part of 'my_list_bloc.dart';

abstract class MyListState extends Equatable {

  @override
  List<Object> get props => [];
}

class MyListInitial extends MyListState {}

class MyListLoadingState extends MyListState {}

class MyListLoadedState extends MyListState {}

class NovelRemovedFromMyListState extends MyListState {
  final String novelId;
  NovelRemovedFromMyListState(this.novelId);

  @override
  List<Object> get props => [novelId];
}