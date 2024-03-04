part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {

  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoadState extends ExploreState {}

class ExploreLoadedState extends ExploreState {}

class SearchTextChanged extends ExploreState {
  final String text;
  SearchTextChanged(this.text);

  @override
  List<Object> get props => [text];
}
