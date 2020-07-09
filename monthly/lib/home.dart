import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants.dart';
import 'screens/calender.dart';
import 'screens/dash_boards.dart';
import 'screens/profile.dart';
import 'screens/stock_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> _screenList = [];

  @override
  void initState() {
    _screenList = [
      DashBoards(),
      StockList(),
      Calender(),
      Profile(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screenList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          new BottomNavigationBarItem(
            icon: new SvgPicture.asset(
              'icons/bar_chart.svg',
              height: 24.0,
              color: _selectedIndex == 0 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Dash Board"),
          ),
          new BottomNavigationBarItem(
            icon: new SvgPicture.asset(
              'icons/addchart.svg',
              height: 24.0,
              color: _selectedIndex == 1 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Stock List"),
          ),
          new BottomNavigationBarItem(
            icon: new SvgPicture.asset(
              'icons/calendar.svg',
              height: 24.0,
              color: _selectedIndex == 2 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Calendar"),
          ),
          new BottomNavigationBarItem(
            icon: new SvgPicture.asset(
              'icons/person.svg',
              height: 24.0,
              color: _selectedIndex == 3 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Profile"),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        onTap: _onItemTapped,
      ),
    );
  }
}
