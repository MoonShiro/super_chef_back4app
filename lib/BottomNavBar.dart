import 'package:flutter/material.dart';

import 'CurrentUserPage.dart';
import 'LandingPage.dart';
import 'PersonalRecipesListPage.dart';
import 'SearchingPage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>{
  int _currentIndex = 0;
  final List _children = [
    const LandingPage(),
    const PersonalRecipesListPage(),
    const SearchingPage(),
    const CurrentUserPage(),
  ];

  @override
  Widget build(BuildContext context) {

    void onTabTapped(int index){
      setState(() {
        _currentIndex = index;
      });
    }
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            iconSize: 25,
            selectedFontSize: 15,
            selectedIconTheme: const IconThemeData(color: Colors.blueAccent),
            selectedItemColor: Colors.blueAccent,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon : Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon : Icon(Icons.menu_book),
                label : 'My Recipes',
              ),
              BottomNavigationBarItem(
                icon : Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon : Icon(Icons.account_circle_rounded),
                label : 'Profile',
              ),
            ]
        ),
      body: (_children[_currentIndex]),
    );
  }

}