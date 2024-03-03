part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class RegistrationEmailTFChanged extends OnboardingEvent{
  final String tfValue;
  RegistrationEmailTFChanged(this.tfValue);
}

class RegistrationPasswordTFChanged extends OnboardingEvent {
  final String tfValue;
  RegistrationPasswordTFChanged(this.tfValue);
}

class RegistrationConfirmPasswordTFChanged extends OnboardingEvent {
  final String tfValue;
  RegistrationConfirmPasswordTFChanged(this.tfValue);
}

class PasswordVisibilityOnEvent extends OnboardingEvent {}

class PasswordVisibilityOffEvent extends OnboardingEvent {}

class ConfirmPassVisibilityOnEvent extends OnboardingEvent {}

class ConfirmPassVisibilityOffEvent extends OnboardingEvent {}

class RegisterClickedEvent extends OnboardingEvent {}

class NameTFChanged extends OnboardingEvent{
  final String tfValue;
  NameTFChanged(this.tfValue);
}

class DobChanged extends OnboardingEvent {
  final String dob;
  DobChanged(this.dob);
}

class NextPageEvent extends OnboardingEvent {}

class LoadCategoriesEvent extends OnboardingEvent {}

class CategorySelectedEvent extends OnboardingEvent {
  final int index;
  CategorySelectedEvent(this.index);
}