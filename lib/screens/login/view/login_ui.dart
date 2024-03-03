import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/common/utils/enums.dart';
import 'package:look8me/screens/login/bloc/login_bloc.dart';

import '../../../routes/screen_name.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    String? emailErrorText;
    String? passwordErrText;
    bool showPassword = false;
    bool isLoginButtonEnabled = false;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        titleSpacing: 5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => locator.get<NavigationService>().goBack(),
              child: const Icon(Icons.arrow_back, color: Colors.grey, size: 30),
            ),
            const Text(
              'Look8Me',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/icons/app_icon.png'),
                      fit: BoxFit.fill)),
            ),
          ],
        ),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => current is LoginSuccessState || current is LoginFailedState || current is ShowAlertDialogState,
        listener: (context, state) {
          if(state is LoginSuccessState) {
            locator.get<NavigationService>().pushNamedAndRemoveUntil(ScreenName.tabs, arguments: 0);
          }
          else if (state is ShowAlertDialogState) {
            CommonWidget.showAlertDialog(
                context: context,
                title: state.title,
                content: state.content,
                primaryButtonText: state.buttonText,
                onButtonPressed: state.onButtonPressed);
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (previous, current) =>
                current is LoginLoadingState || current is LoginFailedState,
            builder: (context, state) => state is LoginLoadingState
                ? CommonWidget.getLoader(
                    text: 'Signing in...',
                    indicatorHeight: 20,
                    indicatorWidth: 20,
                    strokeWidth: 2)
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                current is LoginEmailErrorEnableState ||
                                current is LoginEmailErrorDisableState,
                            builder: (context, state) {
                              if (state is LoginEmailErrorEnableState) {
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
                                      .read<LoginBloc>()
                                      .add(LoginEmailTFChanged(value)),
                                  errorText: emailErrorText);
                            }),
                        const SizedBox(height: 10),
                        BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                current is LoginPasswordErrorEnableState ||
                                current is LoginPasswordErrorDisableState ||
                                current is PasswordVisibilityOnState ||
                                current is PasswordVisibilityOffState,
                            builder: (context, state) {
                              if (state is LoginPasswordErrorEnableState) {
                                passwordErrText = state.errorText;
                              } else if (state
                                  is LoginPasswordErrorDisableState) {
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
                                          .read<LoginBloc>()
                                          .add(PasswordVisibilityOnEvent());
                                    } else {
                                      context
                                          .read<LoginBloc>()
                                          .add(PasswordVisibilityOffEvent());
                                    }
                                  },
                                  onChanged: (value) => context
                                      .read<LoginBloc>()
                                      .add(LoginPasswordTFChanged(value)),
                                  errorText: passwordErrText);
                            }),
                        const SizedBox(height: 10),
                        BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                current is LoginButtonEnableState ||
                                current is LoginButtonDisableState,
                            builder: (context, state) {
                              if (state is LoginButtonEnableState) {
                                isLoginButtonEnabled = true;
                              } else {
                                isLoginButtonEnabled = false;
                              }
                              return CommonWidget.getElevatedButton(
                                  context: context,
                                  name: 'Login',
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  onPressed: isLoginButtonEnabled
                                      ? () => context
                                          .read<LoginBloc>()
                                          .add(LoginClickedEvent())
                                      : null);
                            }),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )),
      ),
    );
  }
}
