import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/routes/screen_name.dart';
import 'package:look8me/screens/welcome/bloc/welcome_bloc.dart';

import '../utils/OnboardingPageViewModel.dart';

class Welcome extends StatelessWidget {
  Welcome({super.key});

  final List<OnboardingPageViewModel> pagesList = [
    OnboardingPageViewModel(
        image: "assets/images/welcome_image1.jpg",
        message: "Enjoy Reading Your Favorite Books Anytime"),
    OnboardingPageViewModel(
        image: "assets/images/welcome_image2.jpg",
        message: "Continue Reading from Where You Stopped"),
    OnboardingPageViewModel(
        image: "assets/images/welcome_image3.jpg",
        message: "Keep Reading You'll Fall in Love"),
    OnboardingPageViewModel(
        image: "assets/images/welcome_image4.jpg",
        message: "Explore Book by Category for Organized Reading"),
    OnboardingPageViewModel(
        image: "assets/images/welcome_image5.jpg",
        message: "Add Books to Your Library Today")
  ];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage(pagesList[index % pagesList.length].image),
                                fit: BoxFit.fill))),
                  ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          pagesList[index % pagesList.length].message,
                          style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                                            ),
                      )
                ],
              );
                          },
                onPageChanged: (page) {
              selectedIndex = page % pagesList.length;
              context
                  .read<WelcomeBloc>()
                  .add(WelcomePageViewChanged(selectedIndex));
                          },
                        )),
          const SizedBox(height: 20),
          BlocBuilder<WelcomeBloc, WelcomeState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < pagesList.length; i++)
                      selectedIndex == i
                          ? CommonWidget.indicator(true)
                          : CommonWidget.indicator(false)
                  ],
                );
              },
              buildWhen: (previous, current) =>
                  current is WelcomePageViewChangedState),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already having Account?',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                  onTap: () {
                    locator.get<NavigationService>().navigateTo(ScreenName.login);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey),
                  ))
            ],
          ),
          const SizedBox(height: 10),
          CommonWidget.getElevatedButton(
              context: context,
              name: 'Get Started',
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              onPressed: () {
                locator.get<NavigationService>().navigateTo(ScreenName.onboarding);
              }),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
