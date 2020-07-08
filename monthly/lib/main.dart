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
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              titleSpacing: 0.0,
              centerTitle: false,
              actions: <Widget>[
                PopupMenuButton<String>(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  onSelected: (String sel) {
                    setState(() {
                      print(sel);
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "detail",
                      child: Text('detail'),
                    ),
                  ],
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                    size: 24.0,
                  ),
                ),
              ],
              elevation: 0.0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "대시보드",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 27),
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
        backgroundColor: Colors.white,
        items: [
          new BottomNavigationBarItem(
            icon: new Image.asset(
              'icons/bar_chart.png',
              height: 24.0,
              color: _selectedIndex == 0 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Dash Board"),
          ),
          new BottomNavigationBarItem(
            icon: new Image.asset(
              'icons/addchart.png',
              height: 24.0,
              color: _selectedIndex == 1 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Stock List"),
          ),
          new BottomNavigationBarItem(
            icon: new Image.asset(
              'icons/calendar.png',
              height: 24.0,
              color: _selectedIndex == 2 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Calendar"),
          ),
          new BottomNavigationBarItem(
            icon: new Image.asset(
              'icons/person.png',
              height: 24.0,
              color: _selectedIndex == 3 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Profile"),
          ),
        ],
        elevation: 0.0,
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
