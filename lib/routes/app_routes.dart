import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/model/novel_model.dart';
import 'package:look8me/routes/screen_name.dart';
import 'package:look8me/screens/error/view/error_ui.dart';
import 'package:look8me/screens/login/bloc/login_bloc.dart';
import 'package:look8me/screens/novel_summary/bloc/novel_summary_bloc.dart';
import 'package:look8me/screens/onboarding/bloc/onboarding_bloc.dart';
import 'package:look8me/screens/onboarding/view/onboarding_view_ui.dart';
import 'package:look8me/screens/tabs/view/tabs_view_ui.dart';
import 'package:look8me/screens/welcome/bloc/welcome_bloc.dart';
import 'package:look8me/screens/welcome/view/welcome_ui.dart';

import '../screens/login/view/login_ui.dart';
import '../screens/novel_summary/view/novel_summary_ui.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ScreenName.welcome:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider(
                create: (context) => WelcomeBloc(), child: Welcome()));
      case ScreenName.onboarding:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BlocProvider(
                    create: (context) => OnboardingBloc(), child: Onboarding()),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                    Tween(begin: const Offset(1, 0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.ease))),
                child: child,
              );
            },
            transitionDuration:
                const Duration(seconds: 1) //any duration you want
            );
      case ScreenName.login:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BlocProvider(
                    create: (context) => LoginBloc(), child: const Login()),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                    Tween(begin: const Offset(1, 0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.ease))),
                child: child,
              );
            },
            transitionDuration:
            const Duration(seconds: 1) //any duration you want
        );
      case ScreenName.tabs:
        final pageIndex = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => Tabs(currentIndex: pageIndex));
      case ScreenName.novelSummary:
        final novel = settings.arguments as Novel;
        return MaterialPageRoute(builder: (context) => BlocProvider(create: (context) => NovelSummaryBloc(novel: novel)..add(NovelSummaryLoadingEvent()), child: const NovelSummary()));
      default:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const ErrorPage());
    }
  }
}
