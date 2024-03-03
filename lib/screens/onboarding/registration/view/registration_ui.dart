import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/common/utils/enums.dart';
import 'package:look8me/routes/screen_name.dart';

import '../../../../common/services/locator.dart';
import '../../../../common/services/navigation_service.dart';
import '../../bloc/onboarding_bloc.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    String? emailErrorText;
    String? passwordErrText;
    String? confirmPassErrText;
    bool showPassword = false;
    bool showConfirmPassword = false;
    bool isRegisterButtonEnabled = false;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) => current is RegistrationSuccessState || current is RegistrationFailedState,
      listener: (context, state) {
        if(state is RegistrationSuccessState) {
          locator.get<NavigationService>().pushNamedAndRemoveUntil(ScreenName.tabs, arguments: 0);
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        buildWhen: (previous, current) =>
            current is RegistrationLoadingState || current is RegistrationFailedState,
        builder: (context, state) => state is RegistrationLoadingState
            ? CommonWidget.getLoader(
                text: 'Signing Up...',
                indicatorHeight: 20,
                indicatorWidth: 20,
                strokeWidth: 2)
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    BlocBuilder<OnboardingBloc, OnboardingState>(
                        buildWhen: (previous, current) =>
                            current is RegistrationEmailErrorEnableState ||
                            current is RegistrationEmailErrorDisableState,
                        builder: (context, state) {
                          if (state is RegistrationEmailErrorEnableState) {
                            emailErrorText = state.errorText;
                          } else {
                            emailErrorText = null;
                          }
                          return CommonWidget.getCredentialTextField(
                              context: context,
                              label: 'Email',
                              isObscure: false,
                              type: TextFieldType.email,
                              onChanged: (value) => context
                                  .read<OnboardingBloc>()
                                  .add(RegistrationEmailTFChanged(value)),
                              errorText: emailErrorText);
                        }),
                    const SizedBox(height: 10),
                    BlocBuilder<OnboardingBloc, OnboardingState>(
                        buildWhen: (previous, current) =>
                            current is RegistrationPasswordErrorEnableState ||
                            current is RegistrationPasswordErrorDisableState ||
                            current is PasswordVisibilityOnState ||
                            current is PasswordVisibilityOffState,
                        builder: (context, state) {
                          if (state is RegistrationPasswordErrorEnableState) {
                            passwordErrText = state.errorText;
                          } else if (state
                              is RegistrationPasswordErrorDisableState) {
                            passwordErrText = null;
                          }
                          return CommonWidget.getCredentialTextField(
                              context: context,
                              label: 'Password',
                              isObscure: !showPassword,
                              type: TextFieldType.password,
                              onTap: () {
                                showPassword = !showPassword;
                                if (showPassword) {
                                  context
                                      .read<OnboardingBloc>()
                                      .add(PasswordVisibilityOnEvent());
                                } else {
                                  context
                                      .read<OnboardingBloc>()
                                      .add(PasswordVisibilityOffEvent());
                                }
                              },
                              onChanged: (value) => context
                                  .read<OnboardingBloc>()
                                  .add(RegistrationPasswordTFChanged(value)),
                              errorText: passwordErrText);
                        }),
                    const SizedBox(height: 10),
                    BlocBuilder<OnboardingBloc, OnboardingState>(
                        buildWhen: (previous, current) =>
                            current
                                is RegistrationConfirmPassErrorEnableState ||
                            current
                                is RegistrationConfirmPassErrorDisableState ||
                            current is ConfirmPassVisibilityOnState ||
                            current is ConfirmPassVisibilityOffState,
                        builder: (context, state) {
                          if (state
                              is RegistrationConfirmPassErrorEnableState) {
                            confirmPassErrText = state.errorText;
                          } else if (state
                              is RegistrationConfirmPassErrorDisableState) {
                            confirmPassErrText = null;
                          }
                          return CommonWidget.getCredentialTextField(
                              context: context,
                              label: 'Confirm Password',
                              isObscure: !showConfirmPassword,
                              type: TextFieldType.password,
                              onTap: () {
                                showConfirmPassword = !showConfirmPassword;
                                if (showConfirmPassword) {
                                  context
                                      .read<OnboardingBloc>()
                                      .add(ConfirmPassVisibilityOnEvent());
                                } else {
                                  context
                                      .read<OnboardingBloc>()
                                      .add(ConfirmPassVisibilityOffEvent());
                                }
                              },
                              onChanged: (value) => context
                                  .read<OnboardingBloc>()
                                  .add(RegistrationConfirmPasswordTFChanged(
                                      value)),
                              errorText: confirmPassErrText);
                        }),
                    const SizedBox(height: 10),
                    BlocBuilder<OnboardingBloc, OnboardingState>(
                        buildWhen: (previous, current) =>
                            current is RegisterButtonEnableState ||
                            current is RegisterButtonDisableState,
                        builder: (context, state) {
                          if (state is RegisterButtonEnableState) {
                            isRegisterButtonEnabled = true;
                          } else {
                            isRegisterButtonEnabled = false;
                          }
                          return CommonWidget.getElevatedButton(
                              context: context,
                              name: 'Register',
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.85,
                              onPressed: isRegisterButtonEnabled
                                  ? () => context
                                      .read<OnboardingBloc>()
                                      .add(RegisterClickedEvent())
                                  : null);
                        }),
                    const SizedBox(height: 10)
                  ],
                ),
              )),
);
  }
}
