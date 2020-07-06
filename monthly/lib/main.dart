import 'package:flutter/material.dart';

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
      theme: ThemeData(),
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0.0,
              title: Text(
                "대시보드",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              floating: true,
              backgroundColor: Colors.white,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: <Widget>[
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Image.asset(
              'icons/bar_chart.png',
              height: 25.0,
              color: _selectedIndex == 0 ? Colors.red : Colors.grey[600],
            ),
            title: Text(
              "Dash Board",
              style: TextStyle(
                  color: _selectedIndex == 0 ? Colors.red : Colors.grey[600]),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Image.asset(
              'icons/addchart.png',
              height: 25.0,
              color: _selectedIndex == 1 ? Colors.red : Colors.grey[600],
            ),
            title: Text(
              "Stock List",
              style: TextStyle(
                  color: _selectedIndex == 1 ? Colors.red : Colors.grey[600]),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Image.asset(
              'icons/calendar.png',
              height: 25.0,
              color: _selectedIndex == 2 ? Colors.red : Colors.grey[600],
            ),
            title: Text(
              "Calendar",
              style: TextStyle(
                  color: _selectedIndex == 2 ? Colors.red : Colors.grey[600]),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Image.asset(
              'icons/person.png',
              height: 25.0,
              color: _selectedIndex == 3 ? Colors.red : Colors.grey[600],
            ),
            title: Text(
              "Profile",
              style: TextStyle(
                  color: _selectedIndex == 3 ? Colors.red : Colors.grey[600]),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
