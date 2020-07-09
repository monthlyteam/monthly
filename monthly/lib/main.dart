import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants.dart';
import 'dash_boards.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'NanumGothic'),
      home: DashBoard(),
    );
  }
}

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DashBoards(),
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
