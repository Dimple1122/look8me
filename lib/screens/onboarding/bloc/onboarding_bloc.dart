import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:look8me/common/model/response_model.dart';
import 'package:look8me/common/services/firebase/firebase_auth_service.dart';
import 'package:look8me/common/services/firebase/firebase_database_service.dart';
import 'package:look8me/common/services/global_database_helper.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/routes/screen_name.dart';

import '../../../common/model/category_model.dart';
import '../../../common/model/user_model.dart';

part 'onboarding_event.dart';

part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  String name = '';
  String dob = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isEmailValid = false;
  bool isRegisterEnabled = false;
  bool isNameValid = false;
  int currentPageIndex = 0;
  List<Category> categories = [];

  OnboardingBloc() : super(OnboardingInitial()) {
    on<RegistrationEmailTFChanged>(emailTextChanged);
    on<RegistrationPasswordTFChanged>(passwordTextChanged);
    on<RegistrationConfirmPasswordTFChanged>(confirmPasswordTextChanged);
    on<PasswordVisibilityOnEvent>(
        (event, emit) => emit(PasswordVisibilityOnState()));
    on<PasswordVisibilityOffEvent>(
        (event, emit) => emit(PasswordVisibilityOffState()));
    on<ConfirmPassVisibilityOnEvent>(
        (event, emit) => emit(ConfirmPassVisibilityOnState()));
    on<ConfirmPassVisibilityOffEvent>(
        (event, emit) => emit(ConfirmPassVisibilityOffState()));
    on<RegisterClickedEvent>(onRegistrationClicked);
    on<NameTFChanged>(nameTextChanged);
    on<DobChanged>(dobChanged);
    on<NextPageEvent>(goToNextPage);
    on<LoadCategoriesEvent>(loadCategories);
    on<CategorySelectedEvent>(categoryTapped);
  }

  FutureOr<void> emailTextChanged(
      RegistrationEmailTFChanged event, Emitter<OnboardingState> emit) {
    email = event.tfValue;
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      isEmailValid = true;
      emit(RegistrationEmailErrorDisableState());
    } else {
      isEmailValid = false;
      if (event.tfValue.isEmpty) {
        emit(RegistrationEmailErrorEnableState('Email is required'));
      } else {
        emit(RegistrationEmailErrorEnableState(
            'Please enter a valid email address.'));
      }
    }
    if (checkRegistrationRequirements()) {
      emit(RegisterButtonEnableState());
    } else {
      emit(RegisterButtonDisableState());
    }
  }

  FutureOr<void> passwordTextChanged(
      RegistrationPasswordTFChanged event, Emitter<OnboardingState> emit) {
    password = event.tfValue;
    if (password.length >= 8) {
      emit(RegistrationPasswordErrorDisableState());
    } else {
      if (event.tfValue.isEmpty) {
        emit(RegistrationPasswordErrorEnableState('Password is required'));
      } else {
        emit(RegistrationPasswordErrorEnableState(
            'Password must have at least 8 characters'));
      }
    }
    if (confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        emit(RegistrationConfirmPassErrorDisableState());
      } else {
        emit(RegistrationConfirmPassErrorEnableState('Passwords do not match'));
      }
    }
    if (checkRegistrationRequirements()) {
      emit(RegisterButtonEnableState());
    } else {
      emit(RegisterButtonDisableState());
    }
  }

  FutureOr<void> confirmPasswordTextChanged(
      RegistrationConfirmPasswordTFChanged event,
      Emitter<OnboardingState> emit) {
    confirmPassword = event.tfValue;
    if (password == confirmPassword) {
      emit(RegistrationConfirmPassErrorDisableState());
    } else {
      emit(RegistrationConfirmPassErrorEnableState('Passwords do not match'));
    }
    if (checkRegistrationRequirements()) {
      emit(RegisterButtonEnableState());
    } else {
      emit(RegisterButtonDisableState());
    }
  }

  FutureOr<void> onRegistrationClicked(_, Emitter<OnboardingState> emit) async {
    emit(RegistrationLoadingState());
    try {
      final response = await locator
          .get<FirebaseAuthService>()
          .registration(email: email, password: password);
      if (response?.type == ResponseType.success) {
        final user = User(
            userId: response?.data as String,
            userName: name,
            userDob: dob,
            categoriesSelected: categories
                .where((element) => element.isSelected)
                .map((selectedCategory) => selectedCategory.category!)
                .toList(),
            userEmail: email);
        await locator.get<FirebaseDatabaseService>().createUser(user);
        final novels = await locator.get<FirebaseDatabaseService>().getNovels();
        final allCategories = await locator.get<FirebaseDatabaseService>().getCategories();
        GlobalDatabaseHelper.init(user, novels, allCategories);
        emit(RegistrationSuccessState());
      } else {
        emit(RegistrationFailedState());
        switch (response?.data) {
          case 'weak-password':
            emit(ShowAlertDialogState(
                title: 'Weak Password',
                content:
                'Your Password is too weak. Choose a stronger password for better security.',
                buttonText: 'OK',
                onButtonPressed: () =>
                    locator.get<NavigationService>().goBack()));
            break;
          case 'email-already-in-use':
            emit(ShowAlertDialogState(
                title: 'User Exist',
                content:
                'This Account already exists. Please try to login.',
                buttonText: 'Login',
                onButtonPressed: () {
                  locator.get<NavigationService>().goBack();
                  locator.get<NavigationService>().pushReplacementNamed(ScreenName.login);
                }));
            break;
          default:
            emit(ShowAlertDialogState(
                title: 'Error',
                content:
                'Something went wrong. Please Try again.',
                buttonText: 'OK',
                onButtonPressed: () =>
                    locator.get<NavigationService>().goBack()));
            break;
        }
      }
    } catch (e) {
      emit(RegistrationFailedState());
      emit(ShowAlertDialogState(
          title: 'Error',
          content:
          'Something went wrong. Please Try again.',
          buttonText: 'OK',
          onButtonPressed: () =>
              locator.get<NavigationService>().goBack()));
    }
  }

  bool checkRegistrationRequirements() {
    return isEmailValid && password.length >= 8 && password == confirmPassword;
  }

  FutureOr<void> nameTextChanged(
      NameTFChanged event, Emitter<OnboardingState> emit) {
    name = event.tfValue;
    bool isValidName = RegExp(r'^[a-zA-Z ]+$').hasMatch(name);
    if (isValidName && name.length >= 2) {
      isNameValid = true;
      emit(NameErrorDisableState());
    } else {
      isNameValid = false;
      if (event.tfValue.isEmpty) {
        emit(NameErrorEnableState('Name can not be Empty.'));
      } else if (event.tfValue.length < 2) {
        emit(NameErrorEnableState('Name must have at least 2 letters.'));
      } else {
        emit(NameErrorEnableState('Please enter a valid name.'));
      }
    }
  }

  FutureOr<void> dobChanged(DobChanged event, Emitter<OnboardingState> emit) {
    dob = event.dob;
    emit(DobChangedState(event.dob));
  }

  FutureOr<void> goToNextPage(
      NextPageEvent event, Emitter<OnboardingState> emit) {
    switch (currentPageIndex) {
      case 0:
        if (name.isEmpty || dob.isEmpty) {
          emit(ShowAlertDialogState(
              title: 'Incomplete Details',
              content:
                  'Please fill in all details to proceed to the next step.',
              buttonText: 'OK',
              onButtonPressed: () =>
                  locator.get<NavigationService>().goBack()));
        } else if (!isNameValid) {
          emit(ShowAlertDialogState(
              title: 'Invalid Details',
              content:
              'Please enter a valid name to proceed to the next step.',
              buttonText: 'OK',
              onButtonPressed: () =>
                  locator.get<NavigationService>().goBack()));
        } else {
          final age = calculateAge(DateFormat('d MMMM, y').parse(dob));
          if (age < 7) {
            emit(ShowAlertDialogState(
                title: 'Age Limit',
                content:
                'Your age should be at least 7 years to proceed to the next step.',
                buttonText: 'OK',
                onButtonPressed: () =>
                    locator.get<NavigationService>().goBack()));
          } else {
            currentPageIndex = currentPageIndex + 1;
            emit(NextPageState(currentPageIndex));
          }
        }
        break;
      case 1:
        if (categories
            .where((element) => element.isSelected)
            .toList()
            .isEmpty) {
          emit(ShowAlertDialogState(
              title: 'Preferences',
              content:
              'Please select at least 1 category to proceed to the next step',
              buttonText: 'OK',
              onButtonPressed: () =>
                  locator.get<NavigationService>().goBack()));
        } else {
          currentPageIndex = currentPageIndex + 1;
          emit(NextPageState(currentPageIndex));
        }
        break;
      case 2:
        currentPageIndex = currentPageIndex + 1;
        emit(NextPageState(currentPageIndex));
        break;
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  FutureOr<void> loadCategories(
      LoadCategoriesEvent event, Emitter<OnboardingState> emit) async {
    emit(CategoriesLoadingState());
    final data = await locator.get<FirebaseDatabaseService>().getCategories();
    categories = data.map((category) => Category(category: category)).toList();
    emit(CategoriesLoadedState());
  }

  FutureOr<void> categoryTapped(
      CategorySelectedEvent event, Emitter<OnboardingState> emit) {
    emit(OnboardingInitial());
    categories.elementAt(event.index).isSelected =
        !categories.elementAt(event.index).isSelected;
    emit(CategorySelectedState(event.index));
  }
}
