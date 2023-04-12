import 'package:flutter/material.dart';

import 'package:flutter_sudoku/screens/home.dart';
import 'package:flutter_sudoku/screens/history.dart';
import 'package:flutter_sudoku/screens/stats.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  //
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = const <Widget>[
    HomePage(),
    HistoryPage(),
    StatsPage(),
  ];
  //
  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: SafeArea(child: _widgetOptions[_selectedIndex]),
      //
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        elevation: 0,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.apps)),
          BottomNavigationBarItem(
              label: "Stats", icon: Icon(Icons.history_outlined)),
          BottomNavigationBarItem(
              label: "Profile", icon: Icon(Icons.bar_chart_outlined)),
        ],
      ),
    );
  }
}
