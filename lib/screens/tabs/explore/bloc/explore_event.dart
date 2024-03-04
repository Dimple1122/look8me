part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class ExploreLoadEvent extends ExploreEvent {}

class SearchTextChangeEvent extends ExploreEvent {
  final String text;
  SearchTextChangeEvent(this.text);
}
