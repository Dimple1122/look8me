part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginEmailErrorEnableState extends LoginState {
  final String errorText;
  LoginEmailErrorEnableState(this.errorText);

  @override
  List<Object> get props => [errorText];
}

class LoginPasswordErrorEnableState extends LoginState {
  final String errorText;
  LoginPasswordErrorEnableState(this.errorText);

  @override
  List<Object> get props => [errorText];
}

class LoginEmailErrorDisableState extends LoginState {}

class LoginPasswordErrorDisableState extends LoginState {}

class LoginButtonEnableState extends LoginState {}

class LoginButtonDisableState extends LoginState {}

class PasswordVisibilityOnState extends LoginState {}

class PasswordVisibilityOffState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailedState extends LoginState {}

class ShowAlertDialogState extends LoginState {
  final String content;
  final String title;
  final String buttonText;
  final Function() onButtonPressed;
  ShowAlertDialogState({required this.content, required this.title, required this.buttonText, required this.onButtonPressed});

  @override
  List<Object> get props => [content];
}
