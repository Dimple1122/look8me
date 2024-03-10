part of 'home_bloc.dart';

abstract class HomeState extends Equatable {

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {}

class ContinueReadingNovelsUpdatedState extends HomeState {}