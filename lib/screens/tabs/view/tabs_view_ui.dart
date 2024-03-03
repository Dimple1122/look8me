import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/screens/tabs/explore/bloc/explore_bloc.dart';
import 'package:look8me/screens/tabs/explore/view/explore_view_ui.dart';
import 'package:look8me/screens/tabs/home/bloc/home_bloc.dart';
import 'package:look8me/screens/tabs/home/view/home_view_ui.dart';
import 'package:look8me/screens/tabs/my_list/view/my_list_view_ui.dart';

class Tabs extends StatefulWidget {
  final int currentIndex;
  const Tabs({super.key, required this.currentIndex});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  final List<Widget> screens = [
    BlocProvider(create: (context) => HomeBloc()..add(HomeLoadingEvent()),child: const Home()),
    BlocProvider(create: (context) => ExploreBloc(),child: const Explore()),
    const MyList()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: screens.elementAt(_currentIndex),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 16,
          unselectedFontSize: 14,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 26),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined),activeIcon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.my_library_books_outlined),activeIcon: Icon(Icons.my_library_books), label: 'My List'),
          ],
          elevation: 0.0,
        ),
      ),
    );
  }

}
