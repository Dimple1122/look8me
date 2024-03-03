part of 'welcome_bloc.dart';

abstract class WelcomeState extends Equatable {

  @override
  List<Object> get props => [];
}

class WelcomeInitial extends WelcomeState {}

class WelcomePageViewChangedState extends WelcomeState {
  final int page;
  WelcomePageViewChangedState(this.page);

  @override
  List<Object> get props => [page];
}