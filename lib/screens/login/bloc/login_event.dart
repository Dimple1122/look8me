part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEmailTFChanged extends LoginEvent {
  final String tfValue;

  LoginEmailTFChanged(this.tfValue);
}

class LoginPasswordTFChanged extends LoginEvent {
  final String tfValue;

  LoginPasswordTFChanged(this.tfValue);
}

class LoginConfirmPasswordTFChanged extends LoginEvent {
  final String tfValue;

  LoginConfirmPasswordTFChanged(this.tfValue);
}

class PasswordVisibilityOnEvent extends LoginEvent {}

class PasswordVisibilityOffEvent extends LoginEvent {}

class LoginClickedEvent extends LoginEvent {}
