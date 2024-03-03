part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class RegistrationEmailErrorEnableState extends OnboardingState {
  final String errorText;
  RegistrationEmailErrorEnableState(this.errorText);

  @override
  List<Object> get props => [errorText];
}

class RegistrationPasswordErrorEnableState extends OnboardingState {
  final String errorText;
  RegistrationPasswordErrorEnableState(this.errorText);

  @override
  List<Object> get props => [errorText];
}

class RegistrationConfirmPassErrorEnableState extends OnboardingState {
  final String errorText;
  RegistrationConfirmPassErrorEnableState(this.errorText);

  @override
  List<Object> get props => [errorText];
}

class RegistrationEmailErrorDisableState extends OnboardingState {}

class RegistrationPasswordErrorDisableState extends OnboardingState {}

class RegistrationConfirmPassErrorDisableState extends OnboardingState {}

class RegisterButtonEnableState extends OnboardingState {}

class RegisterButtonDisableState extends OnboardingState {}

class PasswordVisibilityOnState extends OnboardingState {}

class PasswordVisibilityOffState extends OnboardingState {}

class ConfirmPassVisibilityOnState extends OnboardingState {}

class ConfirmPassVisibilityOffState extends OnboardingState {}

class RegistrationLoadingState extends OnboardingState {}

class RegistrationSuccessState extends OnboardingState {}

class RegistrationFailedState extends OnboardingState {}

class NameErrorEnableState extends OnboardingState {
  final String errorText;
  NameErrorEnableState(this.errorText);

  @override
  List<Object> get props => [errorText];
}

class NameErrorDisableState extends OnboardingState {}

class DobChangedState extends OnboardingState {
  final String dob;
  DobChangedState(this.dob);

  @override
  List<Object> get props => [dob];
}

class ShowAlertDialogState extends OnboardingState {
  final String content;
  final String title;
  final String buttonText;
  final Function() onButtonPressed;
  ShowAlertDialogState({required this.content, required this.title, required this.buttonText, required this.onButtonPressed});

  @override
  List<Object> get props => [content];
}

class NextPageState extends OnboardingState {
  final int currentPageIndex;
  NextPageState(this.currentPageIndex);

  @override
  List<Object> get props => [currentPageIndex];
}

class CategoriesLoadingState extends OnboardingState {}

class CategoriesLoadedState extends OnboardingState {}

class CategorySelectedState extends OnboardingState {
  final int index;
  CategorySelectedState(this.index);

  @override
  List<Object> get props => [index];
}