import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {arguments}) async {
    return await navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  pop(value) {
    return navigatorKey.currentState!.pop(value);
  }

  goBack() {
    return navigatorKey.currentState!.pop();
  }

  popUntil(String desiredRoute) {
    return navigatorKey.currentState!.popUntil((route) {
      return route.settings.name == desiredRoute;
    });
  }

  pushNamedAndRemoveUntil(route, {arguments}) async {
    return await navigatorKey.currentState!.pushNamedAndRemoveUntil(route, (route) => false, arguments: arguments);
  }

  pushReplacementNamed(route, {arguments}) async {
    return await navigatorKey.currentState!.pushReplacementNamed(route, arguments: arguments);
  }

  BuildContext getNavigationContext() {
    return navigatorKey.currentState!.context;
  }

}