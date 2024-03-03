import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/screens/onboarding/bloc/onboarding_bloc.dart';
import 'package:look8me/screens/onboarding/categories_selection/view/categories_selection_ui.dart';
import 'package:look8me/screens/onboarding/personal_details/view/personal_details_view_ui.dart';
import 'package:look8me/screens/onboarding/registration/view/registration_ui.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});

  final List<Widget> onboardingScreens = [
    const PersonalDetails(),
    const CategorySelection(),
    const Registration()
  ];

  final infoMessages = [
    "Your personal details are crucial for enhancing your experience. Rest assured, we prioritize your privacy, and we guarantee not to share your information with any third party.",
    "We are currently collecting categories to gain insights into your preferences. Your participation will help us tailor your experience to better suit your interests.",
    "To register into the app, we require your email and password. Your email will serve as your unique identifier, and the password ensures the security of your account."
  ];

  @override
  Widget build(BuildContext context) {
    bool isFABVisible = true;
    final bloc = BlocProvider.of<OnboardingBloc>(context);
    final pageController = PageController();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        titleSpacing: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                locator.get<NavigationService>().goBack();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.grey,
                size: 30,
              ),
            ),
            BlocBuilder<OnboardingBloc, OnboardingState>(
                buildWhen: (previous, current) => current is NextPageState,
                builder: (context, state) {
                  return Text(
                      'Step ${bloc.currentPageIndex + 1} of ${onboardingScreens.length}',
                      style: const TextStyle(color: Colors.grey, fontSize: 22));
                }),
            BlocBuilder<OnboardingBloc, OnboardingState>(
                buildWhen: (previous, current) => current is NextPageState,
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () => CommonWidget.showAlertDialog(
                        context: context,
                        title: 'Information',
                        content:
                            infoMessages[bloc.currentPageIndex],
                        primaryButtonText: 'OK',
                        onButtonPressed: () => Navigator.of(context).pop()),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                      size: 30,
                    ),
                  );
                })
          ],
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<OnboardingBloc, OnboardingState>(
              buildWhen: (previous, current) => current is NextPageState,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < onboardingScreens.length; i++)
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: i < bloc.currentPageIndex
                                ? Colors.green
                                : Colors.grey),
                        height: 3,
                        width: (MediaQuery.of(context).size.width * 0.9) /
                            onboardingScreens.length,
                      )
                  ],
                );
              }),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: onboardingScreens,
            ),
          ),
        ],
      ),
      floatingActionButton: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is NextPageState) {
            if (bloc.currentPageIndex == onboardingScreens.length - 1) {
              isFABVisible = false;
            }
            pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
          } else if (state is ShowAlertDialogState) {
            CommonWidget.showAlertDialog(
                context: context,
                title: state.title,
                content: state.content,
                primaryButtonText: state.buttonText,
                onButtonPressed: state.onButtonPressed);
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
            return !keyboardIsOpen && isFABVisible
                ? GestureDetector(
                    onTap: () {
                      context.read<OnboardingBloc>().add(NextPageEvent());
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.9)),
                      child: const Icon(Icons.arrow_forward_ios),
                    ))
                : Container();
          },
        ),
      ),
    );
  }
}
