import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screens/calendar.dart';
import 'screens/dash_boards.dart';
import 'screens/profile.dart';
import 'screens/stock_list.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final _dashBoards = GlobalKey<NavigatorState>();
  final _stockList = GlobalKey<NavigatorState>();
  final _calender = GlobalKey<NavigatorState>();
  final _profile = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: WillPopScope(
          onWillPop: _willPopCallback,
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              Navigator(
                key: _dashBoards,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => DashBoards(),
                ),
              ),
              Navigator(
                key: _stockList,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => StockList(),
                ),
              ),
              Navigator(
                key: _calender,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => Calender(),
                ),
              ),
              Navigator(
                key: _profile,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => Profile(),
                ),
              ),
            ],
          ),
        ),
      ),
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
        onTap: (val) => _onTap(val, context),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    var flag = false;
    var cnt = 0;
    setState(() {
      switch (_selectedIndex) {
        case 0:
          _dashBoards.currentState.popUntil((route) {
            if (route.settings.name == null) {
              cnt = 1;
              return route.isFirst;
            } else if (cnt == 0) {
              flag = true;
            } else {
              cnt = 0;
            }
            return route.isFirst;
          });
          break;
        case 1:
          _stockList.currentState.popUntil((route) {
            if (route.settings.name == null) {
              cnt = 1;
              return route.isFirst;
            } else if (cnt == 0) {
              _selectedIndex = 0;
            } else {
              cnt = 0;
            }
            return route.isFirst;
          });
          break;
        case 2:
          _selectedIndex = 0;
          break;
        case 3:
          _profile.currentState.popUntil((route) {
            if (route.settings.name == null) {
              cnt = 1;
              return route.isFirst;
            } else if (cnt == 0) {
              _selectedIndex = 0;
            } else {
              cnt = 0;
            }
            return route.isFirst;
          });
          break;
        default:
      }
    });
    if (flag == true) {
      exit(0);
    }
    return Future(() => false);
  }

  void _onTap(int val, BuildContext context) {
    if (_selectedIndex == val) {
      switch (val) {
        case 0:
          _dashBoards.currentState.popUntil((route) => route.isFirst);
          break;
        case 1:
          _stockList.currentState.popUntil((route) => route.isFirst);
          break;
        case 2:
          _calender.currentState.popUntil((route) => route.isFirst);
          break;
        case 3:
          _profile.currentState.popUntil((route) => route.isFirst);
          break;
        default:
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedIndex = val;
        });
      }
    }
  }
}
