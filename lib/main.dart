import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/services/locator.dart';
import 'package:look8me/common/services/navigation_service.dart';
import 'package:look8me/routes/app_routes.dart';
import 'package:look8me/screens/tabs/view/tabs_view_ui.dart';
import 'package:look8me/screens/welcome/bloc/welcome_bloc.dart';
import 'package:look8me/screens/welcome/view/welcome_ui.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.black.withOpacity(0.8),
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUpLocator();
  Widget? home = BlocProvider<WelcomeBloc>(create: (context) => WelcomeBloc(), child: Welcome());
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if(user != null) {
      home = const Tabs(currentIndex: 0);
    }
    else {
      home = BlocProvider<WelcomeBloc>(create: (context) => WelcomeBloc(), child: Welcome());
    }
    runApp(MyApp(home: home));
  });
}

class MyApp extends StatefulWidget {
  final Widget? home;
  const MyApp({super.key, required this.home});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetworkAvailable = true;
  final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      checkNetworkConnection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: AppRoutes.generateRoute,
      home: widget.home,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    super.dispose();
  }

  void checkNetworkConnection() async {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      const snackBar = SnackBar(duration: Duration(days: 365),backgroundColor: Colors.red,content: Row(mainAxisAlignment: MainAxisAlignment.center ,children: [Text('No internet connection', style: TextStyle(color: Colors.white)), SizedBox(width: 5), Icon(Icons.error_outline)],));
      if(result == ConnectivityResult.none) {
        if(isNetworkAvailable) {
          ScaffoldMessenger.of(locator.get<NavigationService>().getNavigationContext()).showSnackBar(snackBar);
        }
        isNetworkAvailable = false;
      }
      else if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        ScaffoldMessenger.of(locator.get<NavigationService>().getNavigationContext()).removeCurrentSnackBar();
        isNetworkAvailable = true;
      }
    });
  }
}
