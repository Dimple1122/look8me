part of 'welcome_bloc.dart';

abstract class WelcomeEvent extends Equatable{

  @override
  List<Object> get props => [];
}

class WelcomePageViewChanged extends WelcomeEvent {
  final int page;
  WelcomePageViewChanged(this.page);
}
