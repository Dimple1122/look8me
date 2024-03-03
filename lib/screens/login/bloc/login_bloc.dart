import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/model/response_model.dart';
import '../../../common/services/firebase/firebase_auth_service.dart';
import '../../../common/services/firebase/firebase_database_service.dart';
import '../../../common/services/global_database_helper.dart';
import '../../../common/services/locator.dart';
import '../../../common/services/navigation_service.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String email = '';
  String password = '';
  bool isEmailValid = false;
  bool isLoginEnabled = false;

  LoginBloc() : super(LoginInitial()) {
    on<LoginEmailTFChanged>(emailTextChanged);
    on<LoginPasswordTFChanged>(passwordTextChanged);
    on<PasswordVisibilityOnEvent>(
        (event, emit) => emit(PasswordVisibilityOnState()));
    on<PasswordVisibilityOffEvent>(
        (event, emit) => emit(PasswordVisibilityOffState()));
    on<LoginClickedEvent>(onLoginClicked);
  }

  FutureOr<void> emailTextChanged(
      LoginEmailTFChanged event, Emitter<LoginState> emit) {
    email = event.tfValue;
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      isEmailValid = true;
      emit(LoginEmailErrorDisableState());
    } else {
      isEmailValid = false;
      if (event.tfValue.isEmpty) {
        emit(LoginEmailErrorEnableState('Email is required'));
      } else {
        emit(LoginEmailErrorEnableState('Please enter a valid email address.'));
      }
    }
    if (checkLoginRequirements()) {
      emit(LoginButtonEnableState());
    } else {
      emit(LoginButtonDisableState());
    }
  }

  FutureOr<void> passwordTextChanged(
      LoginPasswordTFChanged event, Emitter<LoginState> emit) {
    password = event.tfValue;
    if (password.length >= 8) {
      emit(LoginPasswordErrorDisableState());
    } else {
      if (event.tfValue.isEmpty) {
        emit(LoginPasswordErrorEnableState('Password is required'));
      } else {
        emit(LoginPasswordErrorEnableState(
            'Password must have at least 8 characters'));
      }
    }
    if (checkLoginRequirements()) {
      emit(LoginButtonEnableState());
    } else {
      emit(LoginButtonDisableState());
    }
  }

  FutureOr<void> onLoginClicked(
      LoginClickedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final response = await locator
          .get<FirebaseAuthService>()
          .login(email: email, password: password);
      if (response?.type == ResponseType.success) {
        final user = await locator
            .get<FirebaseDatabaseService>()
            .getUser(response?.data as String);
        final novels = await locator.get<FirebaseDatabaseService>().getNovels();
        final categories = await locator.get<FirebaseDatabaseService>().getCategories();
        if (user != null) {
          GlobalDatabaseHelper.init(user, novels, categories);
        }
        emit(LoginSuccessState());
      } else {
        emit(LoginFailedState());
        switch (response?.data) {
          case 'invalid-credential':
            emit(ShowAlertDialogState(
                title: 'Invalid Credentials',
                content: "Invalid email or password. Please try again.",
                buttonText: 'Try Again',
                onButtonPressed: () =>
                    locator.get<NavigationService>().goBack()));
            break;
          default:
            emit(ShowAlertDialogState(
                title: 'Error',
                content: 'Something went wrong. Please Try again.',
                buttonText: 'OK',
                onButtonPressed: () =>
                    locator.get<NavigationService>().goBack()));
            break;
        }
      }
    } catch (e) {
      emit(LoginFailedState());
      emit(ShowAlertDialogState(
          title: 'Error',
          content: 'Something went wrong. Please Try again.',
          buttonText: 'OK',
          onButtonPressed: () => locator.get<NavigationService>().goBack()));
    }
  }

  bool checkLoginRequirements() {
    return isEmailValid && password.length >= 8;
  }
}
