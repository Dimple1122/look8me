part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class HomeLoadingEvent extends HomeEvent {}

class GetUpdatedContinueReadingNovelsEvent extends HomeEvent {}
